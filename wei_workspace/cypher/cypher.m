


% generate random cypher

function C = cypher()
    C = zeros(26,1);
    for i = 1:26
        % i -> R
        while 1
            R = ceil(rand()*26);
            if ~any(C == R), break; end
        end
        
        C(i) = R;
    end

end