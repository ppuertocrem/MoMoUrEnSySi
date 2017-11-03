within MoMoUrEnSySi.ToFMU;

model HeatPump "Hysteresis controlled smart grid ready heat pump with thermal buffer (complete)"

	import TH = Modelica.Thermal;
	import SI = Modelica.SIunits;

	// Parameters +++++++++++++++++++++++++++++++++++++++++++++
	replaceable package medium_srce=TH.FluidHeatFlow.Media.Water;
	replaceable package medium_sink=TH.FluidHeatFlow.Media.Water;

	parameter SI.Temperature T_srce_in = 293.15 "Source input temperature";  // [K]
	parameter SI.Temperature T_srce_out = 293.15 "Source output temperature";  // [K]
	parameter SI.Temperature T_sink_in = 293.15 "Sink input temperature";  // [K]
	parameter SI.Temperature T_sink_out = 293.15 "Sink output temperature";  // [K]

	// Nodes ++++++++++++++++++++++++++++++++++++++++++++++++++
	replaceable MoMoUrEnSySi.Blocks.prod_hp hp;

	replaceable TH.FluidHeatFlow.Sources.Ambient srce_in(
		medium = medium_srce);
	replaceable TH.FluidHeatFlow.Sources.Ambient sink_in(
		medium = medium_sink);
	replaceable TH.FluidHeatFlow.Sources.Ambient srce_out(
		medium = medium_srce);
	replaceable TH.FluidHeatFlow.Sources.Ambient sink_out(
		medium = medium_sink);

equation

	connect(srce_in.flowPort, hp.flowPort_a1);
	connect(sink_in.flowPort, hp.flowPort_a2);
	connect(hp.flowPort_b1, srce_out.flowPort);
	connect(hp.flowPort_b2, sink_out.flowPort);

end HeatPump;