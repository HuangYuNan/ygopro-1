--超銀河眼の光波龍
--Neo Galaxy-Eyes Cipher Dragon
--Script by nekrozar
function c100911049.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(100911049,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100911049.ctcon)
	e1:SetCost(c100911049.ctcost)
	e1:SetTarget(c100911049.cttg)
	e1:SetOperation(c100911049.ctop)
	c:RegisterEffect(e1)
end
function c100911049.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xe5)
end
function c100911049.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c100911049.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=math.min(Duel.GetMatchingGroupCount(c100911049.ctfilter,tp,0,LOCATION_MZONE,nil),c:GetOverlayCount(),3)
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c100911049.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100911049.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c100911049.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100911049.atktg)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c100911049.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetValue(4500)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_CODE)
			e5:SetValue(100911049)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
		end
		tc=g:GetNext()
	end
end
function c100911049.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
