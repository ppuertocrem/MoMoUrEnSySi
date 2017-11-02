within MoMoUrEnSySi.Base;

model buffer "stratified thermal storage / buffer (3 layers with uniform temperature and constant volumes)"
	extends MoMoUrEnSySi.Partial.PartialFourPorts;

	import SI = Modelica.SIunits;

	// Parameters
	parameter SI.Volume VTan = 3 "Tank volume";  // [m3]
	parameter SI.Length hTan = 1.5 "Height of tank (without insulation)";  // [m]
	parameter SI.Length dIns = 0.05 "Thickness of insulation";  // [m]
	parameter SI.ThermalConductivity kIns = 0.04 "Specific heat conductivity of insulation";  // [W/m/K]

	// Output
	output SI.Temperature t_top "Top layer temperature";  // [K]

protected

	pi = Modelica.Constants.pi

	parameter SI.Length VSeg = VTan / 3 "Volume of a tank segment";  // [m3]
	parameter SI.Length hSeg = hTan / 3 "Height of a tank segment";  // [m]
	parameter SI.Area ATan = VTan/hTan "Tank cross-sectional area (without insulation)";  // [m2]
	parameter SI.Length rTan = sqrt(ATan/pi) "Tank diameter (without insulation)";  // [m]
	parameter SI.Area ASeg = hSeg*2*pi*rTan "Segment side area (without insulation)";  // [m2]

	parameter SI.ThermalConductance conFluSeg = ATan*medium.lamda/hSeg "Thermal conductance between fluid volumes";  // [W/K]
	parameter SI.ThermalConductance conTopSeg = ATan*kIns/dIns "Thermal conductance (top and bottom)";  // [W/K]
	parameter SI.ThermalConductance conSidSeg = ASeg*kIns/dIns "Thermal conductance (side)";  // [W/K]

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