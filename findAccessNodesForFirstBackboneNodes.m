function [Cost, Radius, Member_Node, root] = findAccessNodesForFirstBackboneNodes(Node, x_Node, y_Node, R, CountNode, Backbone_Node)
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
end