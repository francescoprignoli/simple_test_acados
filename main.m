clear all

addpath(genpath([pwd '/build']))
addpath(genpath([pwd '/c_generated_code']))

import casadi.*

%% Horizon parameters
N = 100;
Ts = 0.1; % sampling time [s]
T = N*Ts; % time horizon length [s]

%% Create solver using native MEX interface
if exist('ocp','var')
    ocp.delete;
    clear ocp
end
ocp_model = model_setup(T);
ocp_opts = solver_setup(N,T);
ocp = acados_ocp(ocp_model, ocp_opts);

ocp.generate_c_code;

%% Create solver using template based interface
% Uncomment and run this section to exploit generated code

cd c_generated_code
t_ocp = long_control_mex_solver;
cd ..

% keyboard

disp('SIM native')
results = run_simulation(ocp, N);

% keyboard
disp('SIM templated')
t_results = run_simulation(t_ocp, N);

semilogy(abs(results.u - t_results.u))
disp(['diff control trajs:', num2str(norm(results.u - t_results.u))])
% norm(results.u - t_results.u)


