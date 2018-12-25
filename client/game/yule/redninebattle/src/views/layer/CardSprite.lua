--
-- Author: zhong
-- Date: 2016-06-27 11:36:40
--

local GameLogic = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.models.GameLogic")
local CardSprite = class("CardSprite", cc.Sprite);

--纹理宽高
local CARD_WIDTH = 126;
local CARD_HEIGHT = 175;
local BACK_Z_ORDER = 2;

--小牌纹理宽高
local SMALL_CARD_WIDTH  = 74;
local SMALL_CARD_HEIGHT =103;

------
--set/get
function CardSprite:setDispatched( var )
	self.m_bDispatched = var;
end

function CardSprite:getDispatched(  )
	if nil ~= self.m_bDispatched then
		return self.m_bDispatched;
	end
	return false;
end
------

function CardSprite:ctor()
	self.m_cardData = 0
	self.m_cardValue = 0
	self.m_cardColor = 0
    self.m_cardYype =  0
end

--创建卡牌
function CardSprite:createCard( cbCardData ,cardtype)
	
    
    local sp = CardSprite.new();
    sp.m_cardYype = cardtype
	sp.m_strCardFile = "game_res/im_card.png";

  


	local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(sp.m_strCardFile);
	if nil ~= sp and nil ~= tex and sp:initWithTexture(tex, tex:getContentSize()) then
		sp.m_cardData = cbCardData;

		sp.m_cardValue = GameLogic.GetCardValue(cbCardData) --math.mod(cbCardData, 16)--bit:_and(cbCardData, 0x0F)
		sp.m_cardColor = GameLogic.GetCardColor(cbCardData) --math.floor(cbCardData / 16)--bit:_rshift(bit:_and(cbCardData, 0xF0), 4)
		print("牌值数据", sp.m_cardValue, sp.m_cardColor)
		sp:updateSprite();
        
		--扑克背面
		sp:createBack();

		return sp;
	end
	return nil;
end

--创建开牌记录卡牌(小扑克)
function CardSprite:createSmallCard( cbCardData )
	local small_sp = CardSprite.new();
	small_sp.m_strSmallCardFile = "game_res/im_small_card.png";
	local small_tex = cc.Director:getInstance():getTextureCache():getTextureForKey(small_sp.m_strSmallCardFile);
	if nil ~= small_sp and nil ~= small_tex and small_sp:initWithTexture(small_tex, small_tex:getContentSize()) then
		small_sp.m_cardData = cbCardData;

		small_sp.m_cardValue = GameLogic.GetCardValue(cbCardData) --math.mod(cbCardData, 16)--bit:_and(cbCardData, 0x0F)
		small_sp.m_cardColor = GameLogic.GetCardColor(cbCardData) --math.floor(cbCardData / 16)--bit:_rshift(bit:_and(cbCardData, 0xF0), 4)
		--print("牌值数据", small_sp.m_cardValue, small_sp.m_cardColor)
		small_sp:updateSmallSprite();
		--扑克背面
		--sp:createBack();

		return small_sp;
	end
	return nil;
end

--设置卡牌数值
function CardSprite:setCardValue( cbCardData )
	self.m_cardData = cbCardData;
	self.m_cardValue = GameLogic.GetCardValue(cbCardData) --math.mod(cbCardData, 16) --bit:_and(cbCardData, 0x0F)
	self.m_cardColor = GameLogic.GetCardColor(cbCardData) --math.floor(cbCardData / 16) --bit:_rshift(bit:_and(cbCardData, 0xF0), 4)
	print("牌值", self.m_cardValue, self.m_cardColor)
	self:updateSprite();
end

--更新纹理资源
function CardSprite:updateSprite(  )
	local m_cardData = self.m_cardData;
	local m_cardValue = self.m_cardValue;
	local m_cardColor = self.m_cardColor;
    local m_cardYype = self.m_cardYype;
	self:setTag(m_cardData);

    if m_cardYype == 0  then 
        local rect = cc.rect((m_cardValue - 1) * CARD_WIDTH, m_cardColor * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	    if 0 ~= m_cardData then
		    rect = cc.rect((m_cardValue - 1) * CARD_WIDTH, m_cardColor * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		    if 0x42 == m_cardData then
			    rect = cc.rect(0, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		    elseif 0x41 == m_cardData then
			    rect = cc.rect(CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		    end
	    else
		    --使用背面纹理区域
		    rect = cc.rect(2 * CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	    end
	    self:setTextureRect(rect);
    else
       

       
		local rect  = cc.rect(0, 0, 1,1) 
	    self:setTextureRect(rect)

        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("card_back.png")
		local m_spBack = cc.Sprite:createWithSpriteFrame(frame) 
         
        self:addChild(m_spBack);

        if m_cardValue == 0  then  
            m_cardValue = 1
        end
        local str2 = string.format("card%d.png",m_cardValue) 
        local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame(str2)
		local tempframe2 = cc.Sprite:createWithSpriteFrame(frame2) 
         self:addChild(tempframe2)
         
    end 
	
end

--更新小牌纹理资源
function CardSprite:updateSmallSprite(  )
	local m_cardData = self.m_cardData;
	local m_cardValue = self.m_cardValue;
	local m_cardColor = self.m_cardColor;

	self:setTag(m_cardData);

	local rect = cc.rect((m_cardValue - 1) * SMALL_CARD_WIDTH, m_cardColor * SMALL_CARD_HEIGHT, SMALL_CARD_WIDTH, SMALL_CARD_HEIGHT);
	if 0 ~= m_cardData then
		rect = cc.rect((m_cardValue - 1) * SMALL_CARD_WIDTH, m_cardColor * SMALL_CARD_HEIGHT, SMALL_CARD_WIDTH, SMALL_CARD_HEIGHT);
		if 0x42 == m_cardData then
			rect = cc.rect(0, 4 * SMALL_CARD_HEIGHT, SMALL_CARD_WIDTH, SMALL_CARD_HEIGHT);
		elseif 0x41 == m_cardData then
			rect = cc.rect(SMALL_CARD_WIDTH, 4 * SMALL_CARD_HEIGHT, SMALL_CARD_WIDTH, SMALL_CARD_HEIGHT);
		end
	else
		--使用背面纹理区域
		rect = cc.rect(2 * SMALL_CARD_WIDTH, 4 * SMALL_CARD_HEIGHT, SMALL_CARD_WIDTH, SMALL_CARD_HEIGHT);
	end
	self:setTextureRect(rect);
end

--显示扑克背面
function CardSprite:showCardBack( var )
	if nil ~= self.m_spBack then
		self.m_spBack:setVisible(var);
	end	
end

--创建背面
function CardSprite:createBack(  )
	
    if m_cardYype == 0  then 
         local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(self.m_strCardFile);
	    --纹理区域
	    local rect = cc.rect(2 * CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);

	    local cardSize = self:getContentSize();
        local m_spBack = cc.Sprite:createWithTexture(tex, rect);
        m_spBack:setPosition(cardSize.width * 0.5, cardSize.height * 0.5);
        m_spBack:setVisible(false);
        self:addChild(m_spBack);
        m_spBack:setLocalZOrder(BACK_Z_ORDER);
        self.m_spBack = m_spBack;
    else    
       if GlobalUserItem.bgupai then
       
      
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("card_back.png")
		local m_spBack = cc.Sprite:createWithSpriteFrame(frame) 
     
        self:addChild(m_spBack);
        m_spBack:setLocalZOrder(BACK_Z_ORDER);
        self.m_spBack = m_spBack;

         end
            
    end
   
end

return CardSprite;