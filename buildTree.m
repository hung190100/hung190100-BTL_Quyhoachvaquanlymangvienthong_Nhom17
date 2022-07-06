function [U, hop, P, root] = buildTree(Center_Backbone_Node, Backbone_Node, CountNode, Alpha, Cost, root, x_Node, y_Node)
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
    saveas(gcf,'Cau 31.png');
end