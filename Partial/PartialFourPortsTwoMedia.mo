within MoMoUrEnSySi.Partial;

partial model PartialFourPorts "Partial model of four flow ports component with two different medium"

	import TH = Modelica.Thermal

	replaceable package medium1=TH.FluidHeatFlow.Media.Water
	replaceable package medium2=TH.FluidHeatFlow.Media.Water

	// Input
	TH.Interfaces.FlowPort_a flowPort_a1(medium = medium1);
	TH.Interfaces.FlowPort_a flowPort_a2(medium = medium2);

	// Output
	TH.Interfaces.FlowPort_b flowPort_b1(medium = medium1);
	TH.Interfaces.FlowPort_b flowPort_b2(medium = medium2);

end PartialFourPorts;