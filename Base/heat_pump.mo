within MoMoUrEnSySi.Base;

model heat_pump "heat pump with fixed power"

	// Parameters
	parameter Real p_nominal=100;  // [kW]

	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium_src=Modelica.Thermal.FluidHeatFlow.Media.Medium();
	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium_sink=Modelica.Thermal.FluidHeatFlow.Media.Medium();

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_src_in(medium=medium_src);
	Modelica.Thermal.Interfaces.FlowPort_a port_sink_in(medium=medium_sink);

	Modelica.Blocks.Interfaces.BooleanInput io;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_src_out(medium=medium_src);
	Modelica.Thermal.Interfaces.FlowPort_b port_sink_out(medium=medium_sink);
	Modelica.Blocks.Interfaces.RealOutput p_elec;

	// Nodes
	Modelica.Thermal.FluidHeatFlow.Components.HeatedPipe hex_src(
		medium=medium_src,
		m=0.1,
		T0=293.15,
		V_flowLaminar=0.1,
		dpLamiar=0.1,
		V_flowNominal=1,
		dpNominal=1,
		h_g=0,
		V_flow(start=0));

	Modelica.Thermal.FluidHeatFlow.Components.HeatedPipe hex_sink(
		medium=medium_sink,
		m=0.1,
		T0=293.15,
		V_flowLaminar=0.1,
		dpLamiar=0.1,
		V_flowNominal=1,
		dpNominal=1,
		h_g=0,
		V_flow(start=0));


equation

	// Fixed COP
	cop = 3;

	// Source connections
	connect(port_src_in, hex_src.flowPort_a);
	connect(hex_src.flowPort_b, port_src_out);

	// Sink connections
	connect(port_sink_in, hex_sink.flowPort_a);
	connect(hex_sink.flowPort_b, port_sink_out);

	// Master "SWITCH"
	p_sink = if io then p_nominal else 0.0;

	// Heat
	hex_src.heatPort.Q_flow = p_sink * 1000;  // [W]
	hex_sink.heatPort.Q_flow = p_sink * (1 / cop - 1) * 1000;  // [W]

	// Power consumed
	p_elec = p_sink / cop;

end heat_pump;