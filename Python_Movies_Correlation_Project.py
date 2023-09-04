#!/usr/bin/env python
# coding: utf-8

# In[3]:


#Python Movies Correlation Project
# I used the movies.csv dataset from kaggle.com from: https://www.kaggle.com/datasets/danielgrijalvas/movies
# The specific dataset I used will be linked in to my github repository Portfolio_Project_Datasets


# First let's import the packages we will use in this project
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #Adjusts the configuration of the plots we will create



#read in the data
df = pd.read_csv(r'/Users/pablot.lutz/Desktop/movies.csv')






# In[ ]:





# In[4]:


#lets look at the data
df.head()


# In[5]:


# lets see if there's any missing data
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))


# In[6]:


# and looking at data types in order to clean up some unnecesary decimal places that we dont need
print(df.dtypes)


# In[44]:


#drop rows with missing values
df = df.dropna()



#cleaning data a bit-making floats into integers

df['budget']=df['budget'].astype('int64')

df['votes']=df['votes'].astype('int64')

df['gross']=df['gross'].astype('int64')

df['runtime']=df['runtime'].astype('int64')


# In[8]:





# In[45]:


#checking to see that we changed floats to integers
df.head()


# In[10]:


#create a correct year column
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)


# In[46]:


df.head()


# In[12]:


# Order our Data by Gross revenue

df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[50]:


#display max rows to scroll through the dataset
pd.set_option("display.max_rows", None)


# In[51]:


# looking at the data with max rows and ordered highest gross descending

df=df.sort_values(by=['gross'], inplace=False, ascending=False)



# In[23]:





# In[18]:





# In[55]:


#drop any duplicates
df.drop_duplicates()

df.head()


# In[56]:


# scatterplot with budget vs gross revenue
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Budget')
plt.ylabel('Gross Earnings') 



# In[57]:


#Looking at the data to compare raw vs scatter 
df.head()


# In[58]:


#plot Budget vs gross using seaborn and making it prettier
sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color": "blue"})


# In[23]:


#looking at actual correlation using the pearson method

df.corr(method= 'pearson')


# In[24]:


#0.74 correlation between budget and gross so high correlation
#Votes and Gross has fairly high correlation too
#would like to see what the top 15 movies with a tiny budget but large gross are

correlation_matrix=df.corr(method= 'pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix For Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features') 
plt.show()


# In[38]:


#just doing a bit of exploratory analysis now
# Looking at the top 15 companies by gross revenue

CompanyGrossSum = df.groupby('company')[["gross"]].sum()

CompanyGrossSumSorted = CompanyGrossSum.sort_values('gross', ascending = False)[:15]

CompanyGrossSumSorted = CompanyGrossSumSorted['gross'].astype('int64') 

CompanyGrossSumSorted


        


# In[40]:


#looking at how rating is correlated with gross earnings and it looks like it is
sns.stripplot(x="rating", y="gross", data=df)


# In[41]:


#looking at how genre is correlated with gross earnings

sns.stripplot(x="genre", y="gross", data=df)


# In[43]:





# In[37]:





# In[ ]:




