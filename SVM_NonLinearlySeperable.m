%% SVM Classifier - Non Lineraly Seperable
close all;
clear all;
clc;

%% Input Vectors
% Positive labelled vectors
x11 = [2  2 -2 -2;
       2 -2 -2  2];
% Negative labelled vectors
x22 = [1  1 -1 -1;
       1 -1 -1  1];

%% Finding new x1 and x2 using the formula
x1 = zeros(2,4);
x2 = zeros(2,4);
for i = 1:4
    % Mapping the Positive Vectors
    if sqrt(x11(1,i) * x11(1,i) + x11(2,i) * x11(2,i)) > 2
        x1(1,i) = 4 - x11(2,i) + abs(x11(1,i) - x11(2,i));
        x1(2,i) = 4 - x11(1,i) + abs(x11(1,i) - x11(2,i));
    else
        x1(1,i) = x11(1,i);
        x1(2,i) = x11(2,i);
    end
    % Mapping the Negative Vectors
    if sqrt(x22(1,i) * x22(1,i) + x22(2,i) * x22(2,i)) > 2
        x2(1,i) = 4 - x22(2,i) + abs(x22(1,i) - x22(2,i));
        x2(2,i) = 4 - x22(1,i) + abs(x22(1,i) - x22(2,i));
    else
        x2(1,i) = x22(1,i);
        x2(2,i) = x22(2,i);
    end
end
%% Finding the distance between the two vectors
dist = zeros(4,4);
for i = 1:4
    for j = 1:4
        dist(i,j) = sqrt((x2(1,j)-x1(1,i))^2 + (x2(2,j)-x1(2,i))^2);
    end
end
%% Finding the support vectors
mindist = min(min(dist));
spos = zeros(1,4);
sneg = zeros(1,4);
for i = 1:4
    for j = 1:4
        if dist(i,j) == mindist
            spos(i) = 1;
            sneg(j) = 1;
        end
    end
end
%% Initializing the support vectors
k = 1;
for i = 1:4
    if spos(i) == 1
        s(:,k) = x1(:,i);
        class(1,k) = 1;         % Positive Class - +1
        k = k + 1;
    end
    if sneg(i) == 1
        s(:,k) = x2(:,i);
        class(1,k) = -1;        % Negative Class - -1
        k = k + 1;
    end
end
%% Adding a bias
sdash = s;
sdash(3,:) = 1;
%% Solving for alpha
no_s = k-1;
for i = 1:no_s
    for j = 1:no_s
        s_coeff(i,j) = sum(sdash(:,i).*sdash(:,j));
    end
end
syms x y real
S = solve(s_coeff(1,1)*x + s_coeff(1,2)*y == class(1,1),...
          s_coeff(2,1)*x + s_coeff(2,2)*y == class(1,2));
      
alpha1 = S.x;
alpha2 = S.y;
wdash = alpha1 * sdash(:,1) + alpha2 * sdash(:,2);
w = [wdash(1);wdash(2)];
b = wdash(3);
figure(1);
for i = 1:4
    plot(x1(1,i), x1(2,i),'*','MarkerSize',10,...
                              'MarkerEdgeColor','k',...
                              'MarkerFaceColor','g');grid on;
    set(gca, 'xlim',[-12 12], 'ylim',[-12 12]);
    if i == 1
        hold on;
    end
    if spos(i) == 1
        plot(x1(1,i), x1(2,i),'o','MarkerSize',10,...
                                  'MarkerEdgeColor','k',...
                                  'MarkerFaceColor','r');
    end
end
for i = 1:4
    plot(x2(1,i), x2(2,i),'o','MarkerSize',10,...
                              'MarkerEdgeColor','k',...
                              'MarkerFaceColor','g');
    if sneg(i) == 1
        plot(x2(1,i), x2(2,i),'o','MarkerSize',10,...
                                  'MarkerEdgeColor','k',...
                                  'MarkerFaceColor','r');
    end
end
title('SVM - Linearly Non-Seperable');
xx = -12:1:10;
yy = w * xx + b;
plot(-yy(2,:)-b, yy(1,:), 'r', 'LineWidth', 2);