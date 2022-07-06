function [Center_Backbone_Node] = Prim_Dijkstra(Backbone_Node, Node_Weight, CountNode, root, Cost, x_Node, y_Node)
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
    saveas(gcf,'Cau 1.png');
end