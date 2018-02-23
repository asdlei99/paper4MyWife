function cute (expression)
%CUTE Display symbolic expression in web browser.
%   CUTE(EXPRESSION) displays the symbolic (or string) EXPRESSION
%   in the standard web browser.
%   CUTE works with all modern browsers without the need of additonal
%   plugins.
%
%   Example 
%
%      syms a b c d e f g h i;
%      cute ({inv([a, b, c; d, e, f; g, h, i]); ...
%      sqrt(sinh(a)/acosh(b) - ...
%      42*log(c)) + ...
%      exp(d) + ...
%      e^(1/f)^g^(1/h)-1/(1+1/(1+1/(1+1/i)))})
%
%   is a torture test and displays a column vector.
%   Its first element is 3x3 inverse matrix and
%   the second element is a long non-sense expression
%   involving common functions.
%
%   See also PRETTY.

%   Joerg J. Buchholz
%   http://buchholz.tk

% Ask MuPAD for the expression's LaTeX code.
latex_expression = latex (sym (expression));

% Get rid of MuPAD's strange LaTeX spacing "optimization".
latex_expression = strrep (latex_expression,'\!', '');

% Since \ is the fprintf escape character
% we have to use \\ to produce a backslash in the HTML file.
latex_expression = strrep (latex_expression,'\', '\\');

% This is the real McCoy:
% We create an HTML file that uses a small JavaScript snippet to
% download, install and run the great free MathJax engine on the fly. 
% MathJax interprets the LaTeX code and uses modern CSS and web fonts
% to display the expression in high-quality typography.
html = [...
    '<html xmlns="http://www.w3.org/1999/xhtml"> \n', ...
    '<head> \n', ...
    '    <script \n', ...
    '        type="text/javascript" \n', ...
    '        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"> \n', ...
    '    </script> \n', ...
    '</head> \n', ...
    '<body> \n', ...
    '    $$ \n', ...
    '    ', latex_expression, '\n' ...
    '    $$ \n', ...
    '</body> \n', ...
    '</html>'];

% Buffer the HTML code into a temporary HTML file.
% Any idea how to directly send the HTML code to the browser?
file_name = [tempname, '.htm'];
fid = fopen (file_name, 'w');
fprintf (fid, html);
fclose (fid);

% Open the buffer file in the standard browser.
web (file_name, '-browser')