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

%=========================================================================%
%% Câu 4:

for k = 1:3
    figure;
    axis([0 x 0 y]);  % Giới hạn trục x, y
    hold on;grid on;
    for i=1:length(Node)
        draw(i)=scatter(x_Node(i),y_Node(i),'*k');  % Vẽ các node
        Show_Index(i)=text(x_Node(i)-10,y_Node(i)-20,num2str(i));  % Đánh chỉ số cho các node
    end

    tTraffic = Traffic * (1.2 + (k-1)*0.1);
    % Tính trọng số các node
    Node_Weight=ones(1,length(Node));
    for i = 1:length(Node)
        Node_Weight(i) = sum(tTraffic(i,:));
    end

    % Tính trọng số chuẩn hóa
    Normalized_Weight=zeros(1,length(Node)); % Khởi tạo trọng số chuẩn hóa
    Normalized_Weight = Node_Weight/C; % Chuẩn hóa

    % Phân loại nút Backbone 
    Backbone_Node=[];
    for i=1:length(Node)
        if (Normalized_Weight(i)>W) % W = 2
            % Vẽ các nút Backbone
            Backbone_Node=[Backbone_Node i];
            scatter(x_Node(i),y_Node(i),60,'sr','filled');
            text(x_Node(i)-10,y_Node(i)-20,num2str(i));
        end
    end

    % Tính Cost 
    Cost = zeros(length(Node));
    for i=1:length(Node)
        for j=1:length(Node)
            Cost(j,i)=sqrt((x_Node(j)-x_Node(i))^2+(y_Node(j)-y_Node(i))^2);
        end
    end
    Cost = Cost * 0.4;

    Max_Cost=max(max(Cost));% Tính Max Cost
    Radius = Max_Cost*R; % Tính bán kính tối đa
    Member_Node=[]; % Mảng lưu node thuộc Backbone
    root = zeros(1,CountNode); % Xem node thuộc Backbone nào

    % Xét tất cả các node trừ Backbone
    for i=1:length(Node)
        % Kiểm tra xem nút i có phải là Backbone không
        if (~ismember(i,Backbone_Node))
            % Duyệt các nút backbone
            for j=1:length(Backbone_Node)
                % Kiểm tra xem có nằm trong Radius của Backbone nào
                if (Cost(i,Backbone_Node(j)) <= Radius)
                    root(i) = Backbone_Node(j);
                    Member_Node=[Member_Node i];
                    scatter(x_Node(i),y_Node(i),40,'k','filled');
                    line([x_Node(i) x_Node(root(i))],[y_Node(i) y_Node(root(i))],'Color','k','LineWidth',0.5);
                end
            end
        end
    end

    % Thêm các nút chưa xét
    Uncheck_Node =[];

    for i=1:length(Node)
        % Kiểm tra xem nút i có là nút Backbone hay đã thuộc Backbone hay chưa
        if ((~ismember(i,Backbone_Node)) && (~ismember(i,Member_Node))) 
            Uncheck_Node=[Uncheck_Node i];
            scatter(x_Node(i),y_Node(i),40,'y','filled'); % Các nút chưa được xét được đánh màu vàng
        end
    end

    % Tìm các nút Backbone còn lại
    while(~isempty(Uncheck_Node))
        % Xác định các nút trung tâm - Center of Gravity

        % Tính giá trị hoành độ nút trung tâm x_ctn
        tso = 0;
        mso = 0;
        for i=1:length(Uncheck_Node)
            tso = tso + x_Node(Uncheck_Node(i))*Node_Weight(Uncheck_Node(i));
            mso = mso + Node_Weight(Uncheck_Node(i));
        end
        x_center_of_gravity = tso/mso;
    
        % Tính giá trị tung độ nút trung tâm y_ctn
        tso = 0;
        mso = 0;
        for i=1:length(Uncheck_Node)
            tso = tso + y_Node(Uncheck_Node(i))*Node_Weight(Uncheck_Node(i));
            mso = mso + Node_Weight(Uncheck_Node(i));
        end
        y_center_of_gravity = tso/mso;

        % Hai mảng lưu giá trị distance và weight của các nút Uncheck
        subDis = zeros(1,length(Uncheck_Node));
        subWei = zeros(1,length(Uncheck_Node));
        for i=1:length(Uncheck_Node)
            subDis(i) = sqrt((x_Node(Uncheck_Node(i)) - x_center_of_gravity)^2 + (y_Node(Uncheck_Node(i)) - y_center_of_gravity)^2);
            subWei(i) = Node_Weight(Uncheck_Node(i));
        end
    
        maxDis = max(subDis);
        maxWei = max(subWei);
    
        merit = zeros(1,length(Uncheck_Node)); % Mảng chứa giá trị merit của các nút uncheck
        for i=1:length(Uncheck_Node)
            merit(i) = 0.5*((maxDis - subDis(i))/maxDis) + 0.5*subWei(i)/maxWei;
        end

        % Chọn nút có merit lớn nhất làm nút Backbone mới
        m = find(merit==max(merit)); % m là index của nút có merit lớn nhất trong mảng Uncheck
        n = Uncheck_Node(m); % n là index của nút đó trong 100 node khởi tạo
        Backbone_Node=[Backbone_Node Uncheck_Node(m)]; % Thêm node vào Backbone
        Uncheck_Node(m) = []; % Xóa node ra khỏi Uncheck 
        scatter(x_Node(n),y_Node(n),60,'sr','filled'); 

        % Kiểm tra xem các nút trong uncheck còn lại có nút nào nằm trong Backbone mới không
        tUncheck_Node = Uncheck_Node;
        for i=1:length(tUncheck_Node)
            if (Cost(tUncheck_Node(i), n) <= Radius)
                root(tUncheck_Node(i)) = n;
                Member_Node=[Member_Node tUncheck_Node(i)];
                scatter(x_Node(tUncheck_Node(i)),y_Node(tUncheck_Node(i)),40,'k','filled');
                line([x_Node(tUncheck_Node(i)) x_Node(n)],[y_Node(tUncheck_Node(i)) y_Node(n)],'Color','k','LineWidth',0.5);
                Uncheck_Node(Uncheck_Node==tUncheck_Node(i)) = [];
            end
        end
    end

    % Tìm nút trung tâm

    % Tính tổng trọng số các nút Backbone
    Backbone_weight = zeros(1,length(Backbone_Node));
    for i=1:length(Backbone_Node)
        Backbone_weight(i) = Node_Weight(Backbone_Node(i));
        for j=1:CountNode
            if (root(j) == Backbone_Node(i))
                Backbone_weight(i) = Backbone_weight(i) + Node_Weight(j);
            end
        end
    end

    % Tính moment các nút Backbone
    Moment = zeros(1,length(Backbone_Node));
    for i=1:length(Backbone_Node)
        for j=1:length(Backbone_Node)
            if (i~=j)
                Moment(i) = Moment(i) + Cost(Backbone_Node(i), Backbone_Node(j))*Backbone_weight(j);
            end
        end
    end

    m = find(Moment==min(Moment));  % m là index của nút đó trong mảng Backbone
    Center_Backbone_Node = Backbone_Node(m); 
    scatter(x_Node(Center_Backbone_Node),y_Node(Center_Backbone_Node),60,'sg','filled');
    %saveas(gcf,'Cau 1.png');

    Traffic_Backbone = zeros(length(Backbone_Node));

    for i=1:CountNode
        for j=1:i
            if (tTraffic(i,j) ~= 0)
                if ((~ismember(i,Backbone_Node))) % Nếu i là Backbone thì a = i
                    a = root(i);
                else
                    a = i;
                end

                if ((~ismember(j,Backbone_Node)))
                    b = root(j);
                else
                    b = j;
                end
                a = find(Backbone_Node==a);
                b = find(Backbone_Node==b);
                if (a == b)
                    continue;
                else
                    Traffic_Backbone(a, b) = Traffic_Backbone(a, b) + tTraffic(i, j);
                    Traffic_Backbone(b, a) = Traffic_Backbone(b, a) + tTraffic(i, j);
                end
            end
        end
    end

    U = Center_Backbone_Node;
    V = Backbone_Node;
    V(V==U) = [];
    % Giá Prim-Dijkstra
    hop = zeros(1,numel(Backbone_Node));
    P = []; % Tập hợp các nút home cần xét
    L = zeros(1, CountNode);
    minTemp = 0;

    for i=1:length(L)
        L(i) = inf;
    end

    d = zeros(1, CountNode);

    while(~isempty(V))
        node = U(length(U)); % Lấy giá trị nút Backbone 
     
        for i=1:length(V)
            if (d(node)*Alpha + Cost(node, V(i)) < L(V(i)))
                L(V(i)) = d(node)*Alpha + Cost(node, V(i));
                root(V(i)) = node;
            end
        end
        minTemp = find(L==min(L));
        hop(find(Backbone_Node==minTemp))= hop(find(Backbone_Node==root(minTemp)))+1;
        if (root(minTemp)~= P)
            P = [P, node_index(minTemp)];
        end
     
        U = [U minTemp];
        V(V==minTemp) = [];
        d(minTemp) = Cost(minTemp, root(minTemp)) + d(root(minTemp));
        L(minTemp) = inf;
        line([x_Node(minTemp) x_Node(root(minTemp))],[y_Node(minTemp) y_Node(root(minTemp))],'Color','r','LineWidth',2);
    end

    % Số lượng hop giữa các Backbone
    sum_hop = zeros(length(Backbone_Node));
    root(Center_Backbone_Node)= Center_Backbone_Node;
    for i=1:numel(Backbone_Node)
        for j=1:numel(Backbone_Node)
            if(i==j)
                sum_hop(i,j)=0;
            else
                if(root(Backbone_Node(i))==Backbone_Node(j)||root(Backbone_Node(j))==Backbone_Node(i))
                    sum_hop(i,j) = 1;
                elseif(root(Backbone_Node(i))==root(Backbone_Node(j)))
                    sum_hop(i,j) = 2;
                else
                    sum_hop(i,j)=hop(i)+hop(j);
                end
            end
        end
    end

    % Tìm nút home cho cặp nút (i,j)
    home=zeros(numel(Backbone_Node));
    for i=1:numel(Backbone_Node)
        for j=1:numel(Backbone_Node)
            if (sum_hop(i,j)==2 && (Backbone_Node(i)== Center_Backbone_Node))
                home(i,j)= root(Backbone_Node(j));
            elseif (sum_hop(i,j)==2 && (Backbone_Node(j)== Center_Backbone_Node))
                home(i,j)= root(Backbone_Node(i));
            elseif (sum_hop(i,j)==2 && (Backbone_Node(j)~= Center_Backbone_Node)&& (Backbone_Node(i)~= Center_Backbone_Node))
                home(i,j)= root(Backbone_Node(i));
            elseif sum_hop(i,j)>2
                min_cost = inf;
                A = [Backbone_Node(i) Backbone_Node(j)];
                for k = 1:length(P)
                    if((P(k) ~= A) && (Cost(Backbone_Node(i),P(k)) + Cost(P(k),Backbone_Node(j))< min_cost))
                        min_cost = Cost(Backbone_Node(i),P(k)) + Cost(P(k),Backbone_Node(j));
                        home(i,j) = P(k);
                    end
                end
            end
        end
    end

    % Tính số đường sử dụng và độ sử dụng trên từng liên kết
    tsum_hop = sum_hop;

    % Thêm các liên kết
    maxHop = 0;
    Price = 0;
    for i=1:length(Backbone_Node)
        for j=1:length(Backbone_Node)
            if (tsum_hop(i ,j) > maxHop)
                a = i;
                b = j;
                maxHop = sum_hop(i ,j);
            end
        end
    end
    % a, b là Traffic lớn nhất, index trong backbone
    tsum_hop(a, b) = 0;
    % Giá trị lưu các traffic x
    ultis =[];
    index = 1;
    while(maxHop > 1)
        if (Traffic_Backbone(a, b) ~= 0)
            n = ceil(Traffic_Backbone(a, b)/C);
            U = Traffic_Backbone(a, b)/(n*C);
            Price = Price + n*Traffic_Backbone(a,b);
            if (U > Umin)
                % Thêm liên kết trực tiếp
                c = Backbone_Node(a); d = Backbone_Node(b);
                %fprintf("Them lien ket truc tiep giua nut %i va %i\n",c,d);
                line([x_Node(c) x_Node(d)],[y_Node(c) y_Node(d)],'Color','g','LineWidth',2);
                ultis(index,:) = [Backbone_Node(a) Backbone_Node(b) n U];
                index = index + 1;
            else
                % Chuyển lưu lượng
                Traffic_Backbone(a, find(Backbone_Node==home(a,b))) = Traffic_Backbone(a, find(Backbone_Node==home(a,b))) + Traffic_Backbone(a, b);
                Traffic_Backbone(b, find(Backbone_Node==home(b,a))) = Traffic_Backbone(b, find(Backbone_Node==home(b,a))) + Traffic_Backbone(a, b);
                Traffic_Backbone(find(Backbone_Node==home(b,a)), a) = Traffic_Backbone(find(Backbone_Node==home(b,a)), a) + Traffic_Backbone(a, b);
                Traffic_Backbone(find(Backbone_Node==home(a,b)), b) = Traffic_Backbone(find(Backbone_Node==home(a,b)), b) + Traffic_Backbone(a, b);
            end
        end
        maxHop = 0;
        for i=1:length(Backbone_Node)
            for j=1:length(Backbone_Node)
                if (tsum_hop(i ,j) > maxHop)
                    a = i;
                    b = j;
                    maxHop = tsum_hop(i ,j);
                end
            end
        end
        % a, b là Traffic lớn nhất
        tsum_hop(a, b) = 0;
    end

    for i=1:length(Backbone_Node)
        for j=1:length(Backbone_Node)
            if (tsum_hop(i ,j) == 1)
                n = ceil(Traffic_Backbone(i, j)/C);
                U = Traffic_Backbone(i, j)/(n*C);
                Price = Price + n*Traffic_Backbone(i,j);
                ultis(index,:) = [Backbone_Node(i) Backbone_Node(j) n U];
                index = index + 1;
            end
        end
    end
    %saveas(gcf,'Cau 32.png');
    Price = Price/2;
    fprintf("Price = %f\n", Price)

end







