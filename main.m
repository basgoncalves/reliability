% Results = main (DataMatrix,Headers)
%
% this funtion calculates used the fucntion "calculate_realiability_parameters" to calculate 
% reliability parameters for every pair of trials. 
%
% INPUT
%   DataMatrix = NxM double matrix.
%               N =  number of particiants (rows)
%               M = number of overall trials (columns)
%               TotalData =[];
%
%   Headers = 1xC Cell vector Cell =
%                 C = number of conditions 
%                 description = {};
%-------------------------------------------------------------------------
% OUTPUT
%   Results = cell arrary with ICC, SEM, CV, MDC, heteroscedasticity and Bias values
%   Figures = figures with the Bland-Altman plots for each condition
%   XLSX    = .xlsx file with the results 
%
%-------------------------------------------------------------------------
% DEPENDENCIES: calculate_realiability_parameters (Goncalves, BM 2019), MultiBlandAltman (Goncalves, BM 2019)
%-------------------------------------------------------------------------
% Goncalves, BM (2018)
% https://www.researchgate.net/profile/Basilio_Goncalves
%
%--------------------------------------------------------------------------
% REFERENCES
%
% Weir, J. P. (2005). Quantifying Test-Rest Reliability Using the
% Intraclass Correlation Coefficient and the SEM.
% J Str Cond Res, 19(1), 231–240.
%
% Koo, T. K., & Li, M. Y. (2016). A Guideline of Selecting and
% Reporting Intraclass Correlation Coefficients for Reliability Research.
% Journal of Chiropractic Medicine, 15(2), 155–163.
%
% Field, A. Discovering Statistics Using SPSS (and sex and drugs and rock
% “n” roll).
% 3rd ed. SAGE Publications, Ltd, 2009.
%
% https://au.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval
%
% Atkinson, G., & Nevill, A. M. (1998). Statistical methods for assessing
% measurement error (reliability) in variables relevant to sports medicine.
% Sports Med, 26(4), 217-238
%% START FUNCTION
function Results = main(csvFilePath,ICCtype)

add_to_path()

% if no input is given, select the example.csv 
if nargin < 1
    activeFile = [mfilename('fullpath') '.m'];                                                                         
    cd(fileparts(activeFile))
    csvFilePath = [fileparts(activeFile) fp 'examples' fp 'exampleData.csv'];
end

if nargin < 2
    ICCtype = 'A-1';
end

% create results folder
[mainDir, filename,ext] = fileparts(csvFilePath);
saveDir = [mainDir fp filename '_results']; 
if ~isfolder(saveDir); mkdir(saveDir); end

% read data 
DataTable = readtable(csvFilePath,'VariableNamingRule','preserve');
DataMatrix = table2array(DataTable);
Headers = DataTable.Properties.VariableNames;
[~,Ntrials] = size (DataMatrix);

%% Select columns to be compared based on Headers
% NOTE: columns to be compared should have the exact same name followed by "-Number", e.g. jump-1, jump-2, jump-3

% CHANGE if different charachter before number of trial (e.g. "_")
Dash = strfind(Headers,'-');                             

% find if any of the names does not contatin a dash
if ~isempty(find(cellfun(@isempty,Dash), 1))
    error('make sure all the trials names have are followed by ''-N''(e.g. AB-1, AB-2, ER-1, ER-2)')
    return
end

NameTrial = Headers{1}(1:Dash{1}(end)-1);
NComparisons = 2;
Conditions = 1;

for iCondition = 1 :Ntrials
    PreviousTrial = NameTrial;
    Dash = strfind(Headers{iCondition},'-');
    NameTrial = Headers{iCondition}(1:Dash-1);

    % if it's the last trial AND DIFFERENT name as before
    if iCondition==Ntrials  &&  strcmp (PreviousTrial, NameTrial)==0                
        Conditions (NComparisons) = iCondition;
        NComparisons = NComparisons +1;

    % if it's DIFFERENT name than the previous one
    elseif strcmp (PreviousTrial, NameTrial)==0                             
        Conditions (NComparisons) = iCondition;
        NComparisons = NComparisons +1;
        
    end
    
end

% last condition +1 to get the last group of data 
Conditions (end+1) =  Ntrials+1;                                            
                                

%% Calculate reliability prameters for each condition
                                
Results = {};
column = 2;

% conver Zeros to NaNs
DataMatrix(DataMatrix==0) = NaN;

% loop through every group of same trials (e.g. 1-3 -> 4-5 ...) 
for iCondition = 2:length(Conditions)

    DataPerCondition = DataMatrix (:,Conditions(iCondition-1):Conditions(iCondition)-1);

    % -------------------------------------------------------------------------------------- %
    % ------------- Temporal variable for reliability of each pair of trials ----------------%
    % -------------------------------------------------------------------------------------- %

    Reliability = calculate_realiability_parameters (DataPerCondition,95,ICCtype);

    % -------------------------------------------------------------------------------------- %

    close all

    % get number of rows as output from the ReliCal function
    [Rows1,~] = size (Reliability);            
    [Rows2,~] = size(Results);

    % add one row. First row included the descrition 
    Rows = max(Rows1+1,Rows2);
    if Rows1+1 > Rows2
        Results(2:Rows,1) = Reliability(1:end,1);
    end

    Results(2:Rows1+1,column) = Reliability(1:end,2);
    Results(1,column)= Headers(Conditions(iCondition-1));
    
    column = column+1;
end

%% All the Bland&Altman  plots
cd(saveDir)
MultiBlandAltman (DataMatrix,Headers)

%% Save the file 
varNames = Results(1,:);
varNames{1} = 'Reliability parameter';
dataTable = cell2table(Results(2:end,:), 'VariableNames',varNames);
filename = [saveDir fp 'reliability_results.xlsx'];
writetable(dataTable, filename, 'Sheet', 'Sheet1', 'WriteRowNames', true);
writecell(Results,filename);


%% add current folder and subfolders to path
function add_to_path()

% get dir of the current file
activeFile = [mfilename('fullpath') '.m'];                                                                         
function_path  = fileparts(activeFile);

% add folder and subfolders
addpath(genpath(function_path));




% -------------------------------------- END ------------------------------ %

