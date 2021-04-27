    for i = 1:26
        % go down length of columns
        if i ~= a && i ~= b
        if properFREQ(i,a) > 0 && prevT(i,a) > 0 && prevT(i,b) > 0
        ratio = ratio ...
            + prevT(i,b) * (2 - prevT(i,b))/properFREQ(i,a) ...
            - prevT(i,a) * (2 - prevT(i,a))/properFREQ(i,a);
        
        end
        if properFREQ(i,b) > 0 && prevT(i,a) > 0 && prevT(i,b) > 0
        ratio = ratio ...
            + prevT(i,a) * (2 - prevT(i,a))/properFREQ(i,b) ...
            - prevT(i,b) * (2 - prevT(i,b))/properFREQ(i,b);
        end
        end
        
%         % else
%         ratio = ratio ...
%             + 
%         
%         % ignore neglible transitions, take only those > 0
%         trans_ = properFREQ(i,:) > 0 ...
%             & TsC(i,:) > 0;
%         
%         aToB = (TsC(i,trans_) - properFREQ(i,trans_)) .^2 ...
%         ./ properFREQ(i,trans_);
%         ratio = ratio + sum(aToB);
    end
    
    % row a, 
    trans_ = properFREQ(a,[1:a-1, a+1:b-1, b+1:26]) > 0; ...
            %& TsC(a,[1:a-1, a+1:b-1, b+1,26]) > 0;  % trans(cend / ignore) the NaN / 0s
  
    Dratio = ...
        + prevT(b,trans_) .* (2 - prevT(b,trans_)) ...
        ./ properFREQ(a,trans_) ...
        - prevT(a,trans_) .* (2 - prevT(a,trans_)) ...
        ./ properFREQ(a,trans_);
    
    ratio = ratio + sum(Dratio);
    
    if properFREQ(a,[a]) > 0
    ratio = ratio ...
        + prevT(b,b) * (2 - prevT(b,b)) ...
        / properFREQ(a,a) ...
        - prevT(a,a) * (2 - prevT(a,a)) ...
        / properFREQ(a,a);
    end
    
    if properFREQ(a,[b]) > 0
    ratio = ratio ...
        + prevT(b,a) * (2 - prevT(b,a)) ...
        / properFREQ(a,b) ...
        - prevT(a,b) * (2 - prevT(a,b)) ...
        / properFREQ(a,b);
    end
    
    trans_ = properFREQ(b,[1:a-1, a+1:b-1, b+1:26]) > 0; ...
            %& TsC(b,[1:a-1, a+1:b-1, b+1,26]) > 0;
    
    Dratio = ratio ...
        + prevT(a,trans_) .* (2 - prevT(a,trans_)) ...
        ./ properFREQ(b,trans_) ...
        - prevT(b,trans_) .* (2 - prevT(b,trans_)) ...
        ./ properFREQ(b,trans_);
    
    
    ratio = ratio + sum(Dratio);
    
    if properFREQ(b,[a]) > 0
    ratio = ratio ...
        + prevT(a,b) * (2 - prevT(a,b)) ...
        / properFREQ(b,a) ...
        - prevT(b,a) * (2 - prevT(b,a)) ...
        / properFREQ(b,a);
    end
    
    if properFREQ(b,[b]) > 0
    ratio = ratio ...
        + prevT(a,a) * (2 - prevT(a,a)) ...
        / properFREQ(b,b) ...
        - prevT(b,b) * (2 - prevT(b,b)) ...
        / properFREQ(b,b);
    end
        