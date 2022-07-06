function [Node_Weight, Normalized_Weight, Backbone_Node] = findFirstBackboneNodes(Node, Traffic, C, W, x_Node, y_Node)
    % Tính trọng số các node
    Node_Weight=ones(1,length(Node));
    for i = 1:length(Node)
        Node_Weight(i) = sum(Traffic(i,:));
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
end