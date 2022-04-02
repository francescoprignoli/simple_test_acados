function run_simulation(ocp, N)


disp('run_simulation: using solver')
disp(ocp)
%% Closed loop simulation
Tsim = 50; %[s]
Ts = 0.1; % sampling time [s]

x0 = [0;0;0];
X_log = zeros(3,Tsim/Ts+1);
U_log = zeros(1,Tsim/Ts+1);
t_comp = zeros(1,Tsim/Ts+1);
status = zeros(1,Tsim/Ts+1);
s_max = zeros(1,Tsim/Ts+1);
v_ref = zeros(1,Tsim/Ts+1);

ocp.set('init_x',x0 * ones(1,N+1));
ocp.set('init_u', zeros(1, N));
ocp.set('init_pi', zeros(3, N));

for i = 1:Tsim/Ts+1
% for i = 1:200
    disp(['sim instance ', num2str(i)]);
    % Set parameters
    s_max(i) = 200; %[m]
    v_ref(i) = 36/3.6; %[m/s]
    ocp.set('p', [s_max(i);v_ref(i)]);
    
    % set initial condition
    ocp.set('constr_x0', x0);

    % solve
    ocp.solve();
    ocp.print()

    % computation time
    t_comp(i) = ocp.get('time_tot');

    status(i) = ocp.get('status');
    if status(i)
        warning('Solver failed with error status %d at iteration %d \n', status(i),i);
    end

    % get solution
    u_traj = ocp.get('u');
    x_traj = ocp.get('x');
    pi_traj = ocp.get('pi');

	% set trajectory initialization (if not, set internally using previous solution)
    % shift trajectory for initialization
	ocp.set('init_x', [x_traj(:,2:end), x_traj(:,end)]);
	ocp.set('init_u', [u_traj(:,2:end), u_traj(:,end)]);
	ocp.set('init_pi', [pi_traj(:,2:end), pi_traj(:,end)]);

    % update initial condition
    u0 = u_traj(1);
%     x0 = x_traj(:,2);
    [~,x1] = ode45(@(t,x) plant(t,x,u0),[0 Ts],x0); % feed the plant model with the first control input
    x0 = x1(end,:); % retrieve the state after one time step

    % log state and control
    X_log(:,i) = x0;
    U_log(i) = u0;
end
disp(['Average computation time: ' num2str(1e3*mean(t_comp)) ' [ms]'])
disp(['Max computation time: ' num2str(1e3*max(t_comp)) ' [ms]'])
disp(['Solver failed ' num2str(sum(status ~= 0)) ' times out of ' num2str(i)]); disp(' ')

% Plots
% figure()
% hold on
% plot(0:Ts:Tsim,X_log(1,:))
% plot(0:Ts:Tsim,s_max,'Color','red')
% grid on
% legend('s','s_{max}')

% figure()
% hold on
% plot(0:Ts:Tsim,X_log(2,:))
% plot(0:Ts:Tsim,v_ref,'Color','green')
% grid on
% legend('v','v_{ref}')

% figure()
% plot(0:Ts:Tsim,X_log(3,:))
% grid on
% legend('a')

% figure()
% plot(0:Ts:Tsim,U_log)
% grid on
% legend('j')

% figure()
% stairs(0:Ts:Tsim,status)
% grid on
% legend('status')
% keyboard
end