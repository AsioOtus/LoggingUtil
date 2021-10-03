public protocol CustomizableHandler:
	Handler,
	IsEnabledCustomizable,
	LevelCustomizable,
	DetailsCustomizable,
	DetailsEnablingCustomization,
	ConfigurationCustomizable,
	FiltersCustomizable,
	AnyObject
{ }
