
function G = initgrid(M,N)
    global CHKR_Y;
    G = ones(M, N);
    G(1:M,CHKR_Y) = zeros(M,length(CHKR_Y));
end