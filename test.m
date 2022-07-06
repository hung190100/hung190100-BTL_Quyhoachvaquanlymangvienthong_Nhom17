%% Khai báo
clear; clc; clear global;
% Kích thước mặt phẳng 1000x1000
x = 1000;
y = 1000;
CountNode = 100; % Số lượng các node
W = 2;
R = 0.3; % RPRAM
C = 12; % Dung lượng liên kết
Alpha = 0.4;
Umin = 0.85; % Hệ số Prim-Dijkstra

% Tạo ma trận node kích thước 100x2 chứa tọa độ 100 node
Node = randi(x,CountNode,2); 
x_Node=Node(:,1);   % Hoành độ của node
y_Node=Node(:,2);   % Tung độ của node

% Vẽ đồ thị các node
figure;
axis([0 x 0 y]);  % Giới hạn trục x, y
hold on;grid on;

for i=1:length(Node)
    %figure(1)
    draw(i)=scatter(x_Node(i),y_Node(i),'*k');  % Vẽ các node
    Show_Index(i)=text(x_Node(i)-10,y_Node(i)-20,num2str(i));  % Đánh chỉ số cho các node
end

% Khai báo biến lưu lượng - Traffic
Traffic = setup_Traffic(Node);
Price = priceCalculate(Node, Traffic, C, W, x_Node, y_Node, R, CountNode, Alpha, Umin);
