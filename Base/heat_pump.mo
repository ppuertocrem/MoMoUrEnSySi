within MoMoUrEnSySi.Base;

model heat_pump "heat pump with fixed power"
	extends MoMoUrEnSySi.Partial.PFPTM_io_pelec;

	import SI = Modelica.SIunits;

	// Parameters
	parameter SI.Power p_nominal=100*1E3 "Installed heat pump power";  // [W]
	parameter Real n_carnot = 0.25;

	// Nodes
	Modelica.Thermal.FluidHeatFlow.Components.HeatedPipe hex_srce(
		medium=medium1,
		m=0.1,
		T0=TAmb,
		V_flowLaminar=0.1,
		dpLamiar=0.1,
		V_flowNominal=1,
		dpNominal=1,
		h_g=0,
		V_flow(start=0));

	Modelica.Thermal.FluidHeatFlow.Components.HeatedPipe hex_sink(
		medium=medium2,
		m=0.1,
		T0=TAmb+5,
		V_flowLaminar=0.1,
		dpLamiar=0.1,
		V_flowNominal=1,
		dpNominal=1,
		h_g=0,
		V_flow(start=0));


equation

	// Carnot based COP
	t_srce = flowPort_a1.h / medium1.cp;
	t_sink = flowPort_b2.h / medium2.cp;

	assert(t_srce < t_sink, "Sink and source tempreatures outside feasible region (COP_carnot < 0)");
	cop = n_carnot * pre(t_sink / (t_sink - t_srce));  // !? INITIALISATION !?

	// Source connections
	connect(flowPort_a1, hex_srce.flowPort_a);
	connect(hex_srce.flowPort_b, flowPort_b1);

	// Sink connections
	connect(flowPort_a2, hex_sink.flowPort_a);
	connect(hex_sink.flowPort_b, flowPort_b2);

	// Master "SWITCH"
	p_sink = if io then p_nominal else 0.0;

	// Heat
	hex_srce.heatPort.Q_flow = p_sink;
	hex_sink.heatPort.Q_flow = p_sink * (1 / cop - 1);

	// Power consumed
	power = p_sink / cop;

end heat_pump;