within MoMoUrEnSySi.Partial;

partial model PFPTM_io_pelec "PartialFourPortsTwoMedia with boolen IO input and P_ELEC output"
	extends MoMoUrEnSySi.Partial.PartialFourPortsTwoMedia;

	import SI = Modelica.SIunits;

	// Input
	replaceable input Boolean io "master switch";

	// Output
	output SI.Power power "consumed electrical power";

end PFPTM_io_pelec;