% Generate random data
% Generate random data
x_data = 1:10;
y_data = randi(10, 1, 10);

% Plot the random data
figure;
plot(x_data, y_data, 'bo-');
hold on;

% Define the x values of vertical lines
x_values = x_data;

% Define the y limits for each vertical line as cell array
y_limits = {[1 4], [2 9], [0 8]};

% Call the function to plot multiple vertical lines
cellfun(@(x, y) line([x x], y, 'Color', 'r'), num2cell(x_values), y_limits);

% Add labels
xlabel('X-axis');
ylabel('Y-axis');
title('Random Data with Custom Vertical Lines');

hold off;


%%
test1 = [ 1 4 ; 2 9 ; 0 8];
test2 =  num2cell(test1, 2);
test3 = transpose(test2);

