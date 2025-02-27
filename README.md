# The Effect of a Business Owner's Education and Work Experience on Business Success in Bangladesh
- Investing the effect of a **Business Owner’s Education** and **Work Experience** on **business success in Bangladesh**, using **R Studio**.

# Introduction
- This study investigates the impact of human capital on business success in Bangladesh, focusing
on **work experience** and **formal education**

- We investigate the causal relationship between business success, measured by total sales, and
the owner’s formal education and work experience. The hypothesis is that an owner having more years
of formal education and work experience increases business sales. The rationale is that:
  - 1. Work experience equips individuals with practical skills which may improve leadership
  and decision-making abilities – crucial for driving sales.
  - 2. Formal education may contribute to better analytical and problem-solving abilities, enabling owners to better innovate and adapt to market changes.

# Data
- Data Source: https://microdata.worldbank.org/index.php/catalog/2244/get-microdata
- Key Variables
![Screenshot 2025-02-28 at 5 01 31 AM](https://github.com/user-attachments/assets/d7c0bb5b-8227-48df-b56e-b1b234eb75e4)
- The figure shows substantial variation in sales (50,000 to 1.86 billion Taka). Principal owners’
backgrounds vary greatly, from 0 to 18 years of formal education and 1 to 65 years of work
experience.

- Control and Instrumental Variables
![Screenshot 2025-02-28 at 5 04 10 AM](https://github.com/user-attachments/assets/c4b737e8-b86c-4b87-a0f2-d55b3e86df6b)
- Firm sizes (Figure 2) also vary substantially, from 0 to 2,330 workers, with an
average of 13 workers, indicating a predominance of relatively small firms in the dataset.

# Methodology
- The regression model for analysing the impact of owner education and work experience on sales
is as follows:
  - log(𝑇𝑜𝑡𝑎𝑙 𝑠𝑎𝑙𝑒𝑠 𝑖𝑛 2009) = 𝛽0 + 𝛽1𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝐸𝑑𝑢𝑐𝑎𝑡𝑖𝑜𝑛 + 𝛽2𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝑊𝑜𝑟𝑘 𝐸𝑥𝑝𝑒𝑟𝑖𝑒𝑛𝑐𝑒 + 𝛽3𝑆𝑒𝑐𝑡𝑜𝑟 + 𝛽4𝑇𝑜𝑡𝑎𝑙 𝑊𝑜𝑟𝑘𝑒𝑟𝑠
![Screenshot 2025-02-28 at 5 13 06 AM](https://github.com/user-attachments/assets/559e1744-5d7f-4108-b48a-85a5086514af)

 ### Addressing Omitted Variable Bias
- If education and work experience are correlated with the error term, it can result in biased
coefficient estimates due to omitted variable bias. For example, an owner’s IQ could be an
omitted variable.
- Education is endogenous to IQ because individuals with higher IQs are more
likely to pursue further education. Work experience is endogenous to IQ, as individuals with
lower IQs may be more likely to leave school earlier and enter the workforce.
- To find causal estimates, two-stage least squares (2SLS) analysis is used, because it ensures
explanatory variables are exogenous. For this technique, we need instrumental variables (IV).
The chosen IVs must be relevant to the included regressors and exogenous.

### IV for Education
![Screenshot 2025-02-28 at 5 16 02 AM](https://github.com/user-attachments/assets/f6e9b89e-94df-4022-b42b-7bcc7eb46b7c)
- An IV for education is the owner’s father’s education. To test for relevance, the 1st stage of the
2SLS was used:
  - 𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝐸𝑑𝑢𝑐𝑎𝑡𝑖𝑜𝑛 = 𝜋0 + 𝜋1𝐹𝑎𝑡ℎ𝑒𝑟 𝐸𝑑𝑢𝑐𝑎𝑡𝑖𝑜𝑛 + 𝜋2𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝑊𝑜𝑟𝑘 𝐸𝑥𝑝𝑒𝑟𝑖𝑒𝑛𝑐𝑒 + 𝜋3𝐵𝑢𝑠𝑖𝑛𝑒𝑠𝑠 𝑌𝑒𝑎𝑟𝑠 + 𝜋4𝑆𝑒𝑐𝑡𝑜𝑟 + 𝜋5𝑇𝑜𝑡𝑎𝑙 𝑊𝑜𝑟𝑘𝑒𝑟𝑠
- Since the coefficient estimate on Father Education is statistically significant at the 5% level (p-value
< 5%), Father Education is relevant to Years of Education.
- Father Education is also likely exogenous. While difficult to test, Father Education is mostly set
before birth, hence unlikely to impact their child’s company sales except through the child’s education. For example, the owner’s IQ, an omitted variable in the error term, is uncorrelated
with the father’s education since IQ is an innate internal factor and father’s education is an external
factor.
- Since Father Education is relevant to Years of Education and exogenous, it is a valid IV.

### IV for Work Experience
- An IV for work experience is the years since the business was founded (Business Years). To test
for relevance, the 1st stage of the 2SLS was used:
  - 𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝑊𝑜𝑟𝑘 𝐸𝑥𝑝𝑒𝑟𝑖𝑒𝑛𝑐𝑒! = 𝜋0 + 𝜋#𝐵𝑢𝑠𝑖𝑛𝑒𝑠𝑠 𝑌𝑒𝑎𝑟𝑠1 + 𝜋2𝑌𝑒𝑎𝑟𝑠 𝑜𝑓 𝐸𝑑𝑢𝑐𝑎𝑡𝑖𝑜𝑛 + 𝜋3𝐹𝑎𝑡ℎ𝑒𝑟 𝐸𝑑𝑢𝑐𝑎𝑡𝑖𝑜𝑛 + 𝜋4𝑆𝑒𝑐𝑡𝑜𝑟 + 𝜋5𝑇𝑜𝑡𝑎𝑙 𝑊𝑜𝑟𝑘𝑒𝑟𝑠
![Screenshot 2025-02-28 at 5 18 31 AM](https://github.com/user-attachments/assets/a2e68870-22c5-46f8-874c-ca611cdc203a)
- Since the coefficient estimate on Business Years is statistically significant at the 5% level (p-value
< 5%), Business Years is relevant to Years of Work Experience.
- Business Years may also be exogenous. Using the example of the omitted variable, IQ, an
owner’s IQ does not explain the years since a business was founded. Business Years is mostly
influenced by external factors such as market conditions and regulatory environments which are
unrelated to the owner’s innate intelligence.
- Since Business Years is relevant to Years of Work Experience and Exogenous, it is a valid IV.

# Results
- 2 SLS Results
![Screenshot 2025-02-28 at 5 20 24 AM](https://github.com/user-attachments/assets/f0371e43-780a-412b-828c-b014384fc2ba)

- Multicollinearity test
![Screenshot 2025-02-28 at 5 20 31 AM](https://github.com/user-attachments/assets/41717cc0-b248-4f83-940e-ac3b33d8803c)

- Wald Test 
![Screenshot 2025-02-28 at 5 20 37 AM](https://github.com/user-attachments/assets/a39d696f-0f82-44de-8ff4-c93467164c84)

- Using the 2SLS results, each additional year of education for the owner increases
sales by 13.5%, while each additional year of work experience increases sales by 4.6%,
controlling for the other included variables. Both coefficients are individually statistically
significant at the 5% level (p-value < 5%). They are also jointly significant from the Wald test, with the p-value < 5%, meaning at least one coefficient is statistically significantly different from zero.
- The 2 SLS results show the importance of the 2SLS technique in addressing omitted variable bias. The
OLS coefficient estimate for education was negatively biased, with a lower estimate (0.118)
versus the 2SLS estimate (0.135). Similarly, the OLS coefficient estimate for work experience
was negatively biased, with a lower estimate (0.024) versus the 2SLS estimate (0.046).
- One potential issue which could impact the accuracy of the 2SLS results is possible
multicollinearity between Years of Education and Years of Work Experience. However, the low
variance inflation factors (VIF) and correlation from the multicollinearity test show this is not a significant concern.
- The conclusion so far is that an owner’s education increases revenue more than work experience.
Nevertheless, both increase sales, supporting the hypothesis that an owner’s human capital
increases sales.
- Robustness checks, such as varying model specifications, such as including years of education^2, and Years of Work Expeirence^2 regressions were ran and running another regression using a different year was both statistically significant and did not change the conclusion.
  
# Conclusion
- Our study finds that an owner’s education and work experience positively impact business sales,
with education exerting a greater influence, emphasising the importance of human capital.
Possible threats to our causal conclusions include:
  - 1. Measurement error in the dataset due to the informal nature of self-reporting.
  - 2. Sampling bias in the dataset due to the non-compulsory survey participation.
  - 3. Small sample size.
  - 4. Errors in the selection of instrumental variables due to the difficulty of testing exogeneity.
- This is a particular concern for Business Years as an IV.
It is unclear whether the results can be extrapolated beyond the dataset, such as to other LEDCs.
For more robust results, the same analysis could be done using a different country’s data.
- Nevertheless, this study underscores the significance of human capital in shaping business
outcomes, suggesting to policymakers that investing in educational and vocational initiatives
could enhance Bangladesh’s economic development.
