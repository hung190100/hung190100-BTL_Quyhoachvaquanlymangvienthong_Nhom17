function Traffic = setup_Traffic(Node)
    Traffic = zeros(length(Node));

    for i=1:length(Node)-2
        Traffic(i,i+2)=1;
        Traffic(i+2,i)=1;
    end
    for i=1:length(Node)-54
        Traffic(i,i+54)=2;
        Traffic(i+54,i)=2;
    end
    for i=1:length(Node)-88
        Traffic(i,i+88)=3;
        Traffic(i+88,i)=3;
    end 
    for i=1:length(Node)-98
        Traffic(i,i+98)=4;
        Traffic(i+98,i)=4;
    end

    Traffic(7,28)=18;
    Traffic(28,7)=18;

    Traffic(12,46)=17;
    Traffic(46,12)=17; 
    
    Traffic(27,48)=4;
    Traffic(48,27)=4;
end