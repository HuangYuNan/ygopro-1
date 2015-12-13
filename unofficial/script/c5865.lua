--儀式の下準備
--Script by mercury233

Auxiliary.AddRitualProcGreater=function(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPGTarget(filter))
	e1:SetOperation(Auxiliary.RPGOperation(filter))
	c:RegisterEffect(e1)
	if c.material_filter==nil then
		local code=c:GetOriginalCode()
		local mc=_G["c" .. code]
		mc.tmp_material_filter=filter
	end
end
local mc=_G["c34834619"]
if mc then
	mc.tmp_material_filter=aux.FilterBoolFunction(Card.IsCode,85346853)
end
local mc=_G["c8198712"]
if mc then
	mc.tmp_material_filter=function(c)
		local code=c:GetCode()
		return code==72426662 or code==46427957
	end
end

function c5865.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5865)
	e1:SetTarget(c5865.target)
	e1:SetOperation(c5865.activate)
	c:RegisterEffect(e1)
end
function c5865.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c5865.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c5865.filter2(c,mc)
	if bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if mc.tmp_material_filter==nil then
			local code=c:GetOriginalCode()
			local mc2=_G["c" .. code]
			mc2.initial_effect(mc)
		end
		return mc.tmp_material_filter~=nil and mc.tmp_material_filter(c)
	else return false end
end
function c5865.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5865.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5865.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5865.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(c5865.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
