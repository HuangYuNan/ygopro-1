--方界輪廻
--Houkai Reincarnation
--Script by mercury233
function c100207043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c100207043.condition)
	e1:SetTarget(c100207043.target)
	e1:SetOperation(c100207043.activate)
	c:RegisterEffect(e1)
end
function c100207043.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c100207043.spfilter1(c,e,tp)
	return c:IsSetCard(0xe3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100207043.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsOnField() and at:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c100207043.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100207043.spfilter2(c,e,tp,tc)
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207043.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if tc:IsRelateToEffect(e) and ft>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft=1 end
		local tg=Group.FromCards(tc)
		local g=Duel.GetMatchingGroup(c100207043.spfilter2,1-tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,1-tp,tc)
		if not g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then
			if g:GetCount()<=ft then
				c100207043.spsummon(g,1-tp)
				tg:Merge(g)
			else
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local fg=g:Select(1-tp,ft,ft,nil)
				c100207043.spsummon(fg,1-tp)
				tg:Merge(fg)
				g:Remove(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_GRAVE)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
			local sc=tg:GetFirst()
			while sc do
				c100207043.counter(sc,c)
				sc=tg:GetNext()
			end
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c100207043.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function c100207043.spsummon(g,p)
	local sc=g:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,p,p,false,false,POS_FACEUP_ATTACK)
		sc=g:GetNext()
	end
end
function c100207043.counter(tc,ec)
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	--
	tc:AddCounter(0x1039,1)
	--
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c100207032.condition)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	--
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE)
	tc:RegisterEffect(e3)
end
