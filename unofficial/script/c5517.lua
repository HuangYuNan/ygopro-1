--命削りの宝札
function c5517.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5517)
	e1:SetCost(c5517.cost)
	e1:SetTarget(c5517.target)
	e1:SetOperation(c5517.operation)
	c:RegisterEffect(e1)
end
function c5517.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local dt=3-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if e:GetHandler():IsLocation(LOCATION_HAND) then dt=dt+1 end
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and dt>0 and Duel.IsPlayerCanDraw(tp,dt) end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c5517.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local dt=3-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if e:GetHandler():IsLocation(LOCATION_HAND) then dt=dt+1 end
	if chk==0 then return dt>0 and Duel.IsPlayerCanDraw(tp,dt) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dt)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dt)
end
function c5517.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<3 then Duel.Draw(p,3-ht,REASON_EFFECT) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c5517.disop)
	Duel.RegisterEffect(e1,p)
end
function c5517.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_EFFECT)
end