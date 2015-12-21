--Moon-Light Panther Dancer
--Scripted by Eerie Code @ Ygopro.co - 6947
--multi atk by mercury233
function c5847.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,5846,c5847.mat_filter,1,false,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c5847.splimit)
	c:RegisterEffect(e0)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c5847.tgvalue)
	c:RegisterEffect(e1)
	--Multiple attacks
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5847,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c5847.condition)
	e3:SetOperation(c5847.operation)
	c:RegisterEffect(e3)
	--ATK Up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5847,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(c5847.atkdesop)
	c:RegisterEffect(e4)
end
c5847_attacked=58471
c5847_indestructible=58472

function c5847.mat_filter(c)
	return c:IsSetCard(0xe1) or c:IsSetCard(0x209)
end

function c5847.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c5847.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

function c5847.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c5847.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		--indestructible
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(c5847.reptg)
		e1:SetValue(c5847.repval)
		Duel.RegisterEffect(e1,tp)
		local g=Group.CreateGroup()
		g:KeepAlive()
		e1:SetLabelObject(g)
		--infinte atk to monster
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(9999)
		e2:SetCondition(c5847.atkcon)
		c:RegisterEffect(e2)
		--reg attacked flag to battle target
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
 		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetOperation(c5847.atkop)
		c:RegisterEffect(e3)
		--can not attack one monster more than 2 times
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
 		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetValue(c5847.atktg)
		c:RegisterEffect(e4)
	end
end
function c5847.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and c:GetFlagEffect(c5847_indestructible)==0
end
function c5847.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c5847.repfilter,1,nil,tp) end
	local g=eg:Filter(c5847.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(c5847_indestructible,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c5847.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c5847.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
function c5847.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc then
		tc:RegisterFlagEffect(c5847_attacked,RESET_PHASE+PHASE_END,0,1)
	end
end
function c5847.atktg(e,c)
	return c:GetFlagEffect(c5847_attacked)>=2
end

function c5847.atkdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end