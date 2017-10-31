within MoMoUrEnSySi.Base;

model smart_grid_ready_ctrl "smart grid ready hysteresis ctrl"

	// Parameters
	parameter Real dt_hyst=5;

	// Input
	Modelica.Blocks.Interfaces.IntergerInput io_smart;
	Modelica.Blocks.Interfaces.RealInput t_set;
	Modelica.Blocks.Interfaces.RealInput t_top;

	// Output
	Modelica.Blocks.Interfaces.BooleanOutput io;

	// Nodes
	Modelica.Blocks.Logical.GreaterThreshold positif(threshold=0);
	Modelica.Blocks.Logical.And finalAnd;
	MoMoUrEnSySi.Base.hysteresis hysteresis;
	Modelica.Blocks.Logical.Add add(k1=dt_hyst);

equation

	positif.u = io_smart;
	
	add.u1 = io_smart;
	add.u2 = t_set;
	
	hysteresis.u = t_top;
	hysteresis.uLow = t_set;
	connect(add.y, hysteresis.uHigh);

	connect(positif.y, finalAnd.u1);
	connect(hysteresis.y, finalAnd.u2);
	io = finalAnd.y;

end smart_grid_ready_ctrl;