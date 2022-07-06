function Price = findHomeNodes(Backbone_Node, Center_Backbone_Node, root, hop, Cost, P, Traffic_Backbone, C, Umin, x_Node, y_Node)
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
                maxHop = tsum_hop(i ,j);
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
                %fprintf("Thêm liên kết %d -> %d\n", c, d);
                %fprintf("Hủy liên kết %d -> %d\n", Center_Backbone_Node, c);
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
                ultis(index,:) = [Backbone_Node(i) Backbone_Node(j) n U]
                index = index + 1;
            end
        end
    end
    %[i,j] = find(max(ultis(:,3))==ultis)
    %for m = 1:length(i)
    %    ultis(index,:) = [ultis(i(m),2) ultis(i(m),1) ultis(i(m),3) ultis(i(m),4)]
    %    index = index + 1;
    %end
   
    index
    saveas(gcf,'Cau 32.png');
    Price = Price/2;
    fprintf("Price = %f\n", Price)
    xlswrite('so duong va do su dung',ultis);
end