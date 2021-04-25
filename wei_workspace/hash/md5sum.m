function out = md5sum(in)
% MD5SUM  Obtain a file's MD5 hash value using system calls.
%   OUT = MD5SUM(FILENAME) calculates the MD5 hash value (1) of file IN
%   using system calls. For performance reasons, MD5SUM will hand over to
%   Jan Simon's GETMD5 (2) or DATAHASH (3) if the latter are accessible on
%   the MATLAB search path. The result: reliable calculation of MD5 sums on
%   all modern platforms (GLNXA64, MACI64, PCWIN64) at the best available
%   performance (calls to compiled C-code via GETMD5, Java-calls via
%   DATAHASH, or calls to system functions).
%
%   Example: out = md5sum('directory/file.ext')
%
%   (1) https://en.wikipedia.org/wiki/MD5
%   (2) https://de.mathworks.com/matlabcentral/fileexchange/25921-getmd5
%   (3) https://de.mathworks.com/matlabcentral/fileexchange/31272-datahash
%
%   See also GETMD5 DATAHASH

% Revision history:
% 2017-07-25 added support for DATAHASH
% 2017-06-26 speed improvements + documentation
% 2017-06-14 small speed improvements
% 2017-06-12 initial release

% Check if GetMD5 / DataHash are available
persistent method
if isempty(method)
    if exist(['GetMD5.',mexext],'file') == 3
        method = 1;
    elseif exist('DataHash.m','file') == 2
        method = 2;
    else
        method = 3;
    end
end

switch method
    case 1  % Pass input to GetMD5
        out = GetMD5(in,'file');
        
    case 2  % Pass input to DataHash
        out = DataHash(in,struct('Input','file'));
        
    case 3  % Obtain MD5 sum via system calls
        validateattributes(in,{'char'},{'nonempty','row'});
        if ~java.io.File(in).exists
            error('File not found: %s',in)
        end
        switch computer
            case 'GLNXA64'
                [~,tmp] = system(['md5sum ' in]);
            case 'MACI64'
                [~,tmp] = system(['md5 -r ' in]);
            case 'PCWIN64'
                [~,tmp] = system(['CertUtil -hashfile ' in ' MD5']);
            otherwise
                error('%s does not support %s',mfilename,computer)
        end
        out = regexp(tmp,'^\w{32}','match','once','lineanchors');
end