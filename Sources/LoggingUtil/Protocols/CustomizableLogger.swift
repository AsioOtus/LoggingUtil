public protocol CustomizableLogger:
	Logger,
	IsEnabledCustomizable,
	LevelCustomizable,
	DetailsCustomizable,
	ConfigurationCustomizable
{ }
