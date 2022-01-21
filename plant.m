function x_dot = plant(t,x,u)
x_dot = [x(2);
         x(3);
         u];
end