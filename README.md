## Description

This module calculates reliability parameters for every pair of trials using the function "calculate_realiability_parameters".

## InputC
- `csvFilePath` : path of the csv file containing each condition (column) and trials (row) (example file in https://github.com/basgoncalves/reliability/blob/main/examples/exampleData.csv)
- `ICCtype` (optional) : following the recommendations from McGraw et al. (1996) can be selected as:
                '1-1','1-k','C-1','C-k','A-1' (default) ,'A-k'
  
## Output

- `Results`: Cell array with ICC, SEM, CV, MDC, heteroscedasticity, and Bias values
- `Figures`: Figures with the Bland-Altman plots for each condition
- `XLSX`: .xlsx file with the results

## Dependencies

- `calculate_realiability_parameters` (Goncalves, BM 2019)
- `MultiBlandAltman` (Goncalves, BM 2019)

## Author

Goncalves, BM (2018)
- [ResearchGate](https://www.researchgate.net/profile/Basilio_Goncalves)

## References

- Weir, J. P. (2005). Quantifying Test-Rest Reliability Using the Intraclass Correlation Coefficient and the SEM. J Str Cond Res, 19(1), 231–240.
- Koo, T. K., & Li, M. Y. (2016). A Guideline of Selecting and Reporting Intraclass Correlation Coefficients for Reliability Research. Journal of Chiropractic Medicine, 15(2), 155–163.
- Field, A. Discovering Statistics Using SPSS (and sex and drugs and rock “n” roll). 3rd ed. SAGE Publications, Ltd, 2009.
- [MATLAB Answers - Confidence Interval](https://au.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval)
- Atkinson, G., & Nevill, A. M. (1998). Statistical methods for assessing measurement error (reliability) in variables relevant to sports medicine. Sports Med, 26(4), 217-238
- McGraw, K. O. & Wong, S. P. Forming inferences about some intraclass correlation coefficients. Psychol. Methods 1, 30–46 (1996).

## Usage

To use this function, simply provide the `csvFilePath` and the function will generate reliability parameters, figures, and an Excel file containing the results.

### Example

Run 'main' without inputs to use the example files.