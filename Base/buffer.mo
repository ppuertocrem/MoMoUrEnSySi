within MoMoUrEnSySi.Base;

model buffer "stratified thermal storage / buffer (3 layers with uniform temperature and constant volumes)"

	// Parameters
	parameter Modelica.SIunits.Temperature TAmb = 293.15 "Ambient temperature";  // [K]
	parameter Modelica.SIunits.Volume VTan = 3 "Tank volume";  // [m3]
	parameter Modelica.SIunits.Length hTan = 1.5 "Height of tank (without insulation)";  // [m]
	parameter Modelica.SIunits.Length dIns = 0.05 "Thickness of insulation";  // [m]
	parameter Modelica.SIunits.ThermalConductivity kIns = 0.04 "Specific heat conductivity of insulation";  // [W/m/K]

	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_prod_in(medium=medium);
	Modelica.Thermal.Interfaces.FlowPort_a port_cons_in(medium=medium);

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_prod_out(medium=medium);
	Modelica.Thermal.Interfaces.FlowPort_b port_cons_out(medium=medium);
	Modelica.Blocks.Interfaces.RealOutput t_top;

protected

	pi = Modelica.Constants.pi

	parameter Modelica.SIunits.Length VSeg = VTan / 3 "Volume of a tank segment";  // [m3]
	parameter Modelica.SIunits.Length hSeg = hTan / 3 "Height of a tank segment";  // [m]
	parameter Modelica.SIunits.Area ATan = VTan/hTan "Tank cross-sectional area (without insulation)";  // [m2]
	parameter Modelica.SIunits.Length rTan = sqrt(ATan/pi) "Tank diameter (without insulation)";  // [m]
	parameter Modelica.SIunits.Area ASeg = hSeg*2*pi*rTan "Segment side area (without insulation)";  // [m2]

	parameter Modelica.SIunits.ThermalConductance conFluSeg = ATan*Medium.lamda/hSeg "Thermal conductance between fluid volumes";  // [W/K]
	parameter Modelica.SIunits.ThermalConductance conTopSeg = ATan*kIns/dIns "Thermal conductance (top and bottom)";  // [W/K]
	parameter Modelica.SIunits.ThermalConductance conSidSeg = ASeg*kIns/dIns "Thermal conductance (side)";  // [W/K]

equation

	// Uniform pressure and mass conservation
	port_prod_in.p = port_cons_in.p = port_prod_out.p = port_cons_out.p;
	m_flow_prod = port_prod_in.m_flow = port_prod_out.m_flow;
	m_flow_cons = port_cons_in.m_flow = port_cons_out.m_flow;

	// Resultant flows from m_flow_prod and m_flow_cons (if m_flow_prod = m_flow_cons then m_up = m_do = 0.0)
	m_up = if m_flow_cons > m_flow_prod then (m_flow_cons - m_flow_prod) else 0.0;
	m_do = if m_flow_cons < m_flow_prod then (m_flow_prod - m_flow_cons) else 0.0;

	// Input temperature
	t_in_prod = port_prod_in.h / medium.cp;
	t_in_cons = port_cons_in.h / medium.cp;

	// Heat flows by conduction between layers and with environnement
	q_cond_top = (conSidSeg + conTopSeg) * (TAmb - t_top) + conFluSeg * (t_mid - t_top);
	q_cond_mid = conSidSeg * (TAmb - t_mid) + conFluSeg * (t_top - 2*t_mid + t_bot);
	q_cond_bot = (conSidSeg + conTopSeg) * (TAmb - t_bot) + conFluSeg * (t_mid - t_bot);

	// Heat flows by mass exchange (input and output ports + exchange between layers)
	q_port_top = medium.cp * (m_flow_prod * t_in_prod - m_flow_cons * t_top + m_up * t_mid - m_do * t_top)
	q_port_mid = medium.cp * (m_up * (t_bot - t_mid) + m_do * (t_top - t_mid))
	q_port_bot = medium.cp * (m_flow_cons * t_in_cons - m_flow_prod * t_bot - m_up * t_bot + m_do * t_mid)

	// Heat conservation equation
	VSeg * medium.rho * medium.cp * der(t_top) = q_cond_top + q_port_top 
	VSeg * medium.rho * medium.cp * der(t_mid) = q_cond_mid + q_port_mid
	VSeg * medium.rho * medium.cp * der(t_bot) = q_cond_bot + q_port_bot

	// Output temperatures
	port_prod_out.h = medium.cp * t_bot;
	port_cons_out.h = medium.cp * t_top;

end buffer;