public protocol CustomizableHandler:
	Handler,
	LevelCustomizable,
	DetailsCustomizable,
	DetailsEnablingCustomization,
	ConfigurationCustomizable,
	FiltersCustomizable,
	AnyObject
{ }
