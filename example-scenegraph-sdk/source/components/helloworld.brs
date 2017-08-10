sub init()
    
   
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    m.mParticleTask.ObserveField("identityResult", "onIdentityResult")
    m.mParticleTask.ObserveField("currentUser", "onCurrentUserChanged")
    m.mparticle = mParticleSGBridge(m.mParticleTask)
    mpConstants = mparticleconstants()
    m.mpidLabel = m.top.findNode("mpidLabel")
    m.userAttributesLabel = m.top.findNode("userAttributesLabel")
    m.userIdentitiesLabel = m.top.findNode("userIdentitiesLabel")
    m.emailTextEdit = m.top.findNode("emailTextEdit")
    m.emailTextEdit.setFocus(true)
    identityApiRequest = {}
    identityApiRequest.userIdentities = {}
    identityApiRequest.userIdentities[mpConstants.IDENTITY_TYPE.OTHER] = "other2"
    m.mparticle.identity.modify(identityApiRequest)
    m.mparticle.logEvent("hello world!")
    m.mparticle.identity.setUserAttribute("example attribute key", "example attribute value")
    m.mparticle.identity.setUserAttribute("example attribute array", ["foo", "bar"])

    m.mparticle.logScreenEvent("hello screen!")
    
    product = mpConstants.Product.build("foo-sku", "foo-name", 123.45)
    actionApi = mpConstants.ProductAction
    productAction = actionApi.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    actionApi.setCheckoutStep(productAction, 5)
    actionApi.setCouponCode(productAction, "foo-coupon-code")
    actionApi.setShippingAmount(productAction, 33.42)
    
    promotionList = [mpConstants.Promotion.build("foo-id", "foo-name", "foo-creative", "foo-position")]
    promotionAction = mpConstants.PromotionAction.build(mpConstants.PromotionAction.ACTION_TYPE.VIEW, promotionList)
    
    impressions = [mpConstants.Impression.build("foo-list", [product])]
    m.mparticle.setSessionAttribute("foo attribute key", "bar attribute value")
    m.mparticle.logCommerceEvent(productAction, promotionAction, impressions, {"foo-attribute":"bar-attribute-value"})
end sub

function onIdentityResult() as void
    print "IdentityResult: " + formatjson(m.mParticleTask.identityResult)
end function

function onCurrentUserChanged() as void
    print "Current user: " + formatjson(m.mParticleTask.currentUser)
    m.mpidLabel.text = "MPID: " + m.mParticleTask.currentUser.mpid
    m.userAttributesLabel.text = "User attributes: " + formatjson(m.mParticleTask.currentUser.userAttributes)
    m.userIdentitiesLabel.text = "User identities: " + formatjson(m.mParticleTask.currentUser.userIdentities)
    
    m.mparticle.logEvent("User Changed", mparticleconstants().CUSTOM_EVENT_TYPE.USER_CONTENT, m.mParticleTask.currentUser)
end function