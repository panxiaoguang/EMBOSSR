# EMBOSSR
This is a script that call EMBOSS needle alignment tool in R

# How to use

```R
source("EMBOSS_needle.wrap.R")
needle(s1,s2)  # s1,s2 is the subject and pattern sequences respectively
```

for example,

```R

s1<-"GGAAGACAGTGTATTTAATTTAAGGCATAACGGCTGTATCAGTGTGGCTGCAGTCAAAATAGAAACCATTTCTAAAATAG"
s2<-"CACTGATACTGCCGTGAATC"

needle(s2,s1,exe_path='please input your EMBOSS needle path')

$similarity
[1] "16/80 (20.0%)"

$score
[1] 64

$subject
[1] "------------------------GATTCACGGCAGTATCAGTG------------------------------------"

$pattern
[1] "GGAAGACAGTGTATTTAATTTAAGGCATAACGGCTGTATCAGTGTGGCTGCAGTCAAAATAGAAACCATTTCTAAAATAG"


```

You can see that s2 can not be aligned well to the s1, but the reverse_complement sequence can be done, then the revCom. seq will be used .
