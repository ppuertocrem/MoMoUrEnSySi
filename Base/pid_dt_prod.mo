within MoMoUrEnSySi.Base;

model pid_dt_prod "PID ctrl for defined dt at heat source"

	// Parameters
	parameter Real dt_prod=20;  // [deg.C]

	// Input
	Modelica.Blocks.Interfaces.RealOutput dt_src;

	// Output
	Modelica.Blocks.Interfaces.RealOutput alpha;

	// Nodes
	Modelica.Blocks.Continuous.LimPID pid;

end pid_dt_prod;