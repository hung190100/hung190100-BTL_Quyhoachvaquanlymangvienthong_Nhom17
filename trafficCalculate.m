function Traffic_Backbone = trafficCalculate(Backbone_Node, CountNode, Traffic, root, Traffic_Backbone)
    Traffic_Backbone = zeros(length(Backbone_Node));

    for i=1:CountNode
        for j=1:i
            if (Traffic(i,j) ~= 0)
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
                    Traffic_Backbone(a, b) = Traffic_Backbone(a, b) + Traffic(i, j);
                    Traffic_Backbone(b, a) = Traffic_Backbone(b, a) + Traffic(i, j);
                    %fprintf("a = %d, b = %d, Node 1 = %d, Node 2 = %d, i = %d, j = %d\n", a, b, Backbone_Node(a), Backbone_Node(b), i, j);
                end
            end
        end
    end
    Traffic_Backbone
    tTraffic_Backbone = zeros(length(Backbone_Node)+1);
    for i=2:length(tTraffic_Backbone)
        for j=2:length(tTraffic_Backbone)
           tTraffic_Backbone(i,j) = Traffic_Backbone(i-1,j-1);
        end
    end

    for i=2:length(tTraffic_Backbone)
        tTraffic_Backbone(1,i) = Backbone_Node(i-1);
        tTraffic_Backbone(i,1) = Backbone_Node(i-1);
    end
    tTraffic_Backbone(1,1)=nan;
    tTraffic_Backbone
    xlswrite('Traffic_Backbone',Traffic_Backbone);
    xlswrite('tTraffic_Backbone',tTraffic_Backbone);
end