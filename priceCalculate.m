function Price = priceCalculate(Node, Traffic, C, W, x_Node, y_Node, R, CountNode, Alpha, Umin)
    %% Tìm các nút Backbone đầu tiên
    [Node_Weight, Normalized_Weight, Backbone_Node] = findFirstBackboneNodes(Node, Traffic, C, W, x_Node, y_Node);

    %% Tìm các nút truy nhập cho các nút Backbone đầu tiên
    [Cost, Radius, Member_Node, root] = findAccessNodesForFirstBackboneNodes(Node, x_Node, y_Node, R, CountNode, Backbone_Node);

    %% Kiếm các nút chưa được xét
    [Backbone_Node, root, Member_Node] = findUncheckNodes(Node, Backbone_Node, Member_Node, x_Node, y_Node, Node_Weight, Cost, Radius, root);

    %% Xây dựng cây Prim-Dijkstra
    [Center_Backbone_Node] = Prim_Dijkstra(Backbone_Node, Node_Weight, CountNode, root, Cost, x_Node, y_Node);

    %=========================================================================%
    %% Câu 2
    % Tính lưu lượng các nút Backbone
    Traffic_Backbone = trafficCalculate(Backbone_Node, CountNode, Traffic, root);

    %=========================================================================%
    %% Câu 3
    % Xây dựng cây
    [U, hop, P, root] = buildTree(Center_Backbone_Node, Backbone_Node, CountNode, Alpha, Cost, root, x_Node, y_Node);

    %% Tính toán độ sử dụng và thêm liên kết
    Price = findHomeNodes(Backbone_Node, Center_Backbone_Node, root, hop, Cost, P, Traffic_Backbone, C, Umin, x_Node, y_Node);

end