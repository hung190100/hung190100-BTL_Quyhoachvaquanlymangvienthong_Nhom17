function [Backbone_Node, root, Member_Node] = findUncheckNodes(Node, Backbone_Node, Member_Node, x_Node, y_Node, Node_Weight, Cost, Radius, root)
    % Thêm các nút chưa xét
    Uncheck_Node =[];

    for i=1:length(Node)
        % Kiểm tra xem nút i có là nút Backbone hay đã thuộc Backbone nào hay chưa
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

        %xlswrite('Backbone_Node',Backbone_Node); % Lưu lại Backbone node, mỗi khi chạy nhớ xóa file này đi ***
        
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
end