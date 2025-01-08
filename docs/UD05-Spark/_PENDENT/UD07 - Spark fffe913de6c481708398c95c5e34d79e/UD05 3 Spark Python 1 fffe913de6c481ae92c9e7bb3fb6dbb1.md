# UD05 3. Spark Python 1.

[https://www.udemy.com/course/taming-big-data-with-apache-spark-hands-on/learn/lecture/3709156#overview](https://www.udemy.com/course/taming-big-data-with-apache-spark-hands-on/learn/lecture/3709156#overview)

[https://grouplens.org/datasets/movielens/](https://grouplens.org/datasets/movielens/)

[ratings-counter.py](<./UD05 3 Spark Python 1 fffe913de6c481ae92c9e7bb3fb6dbb1/ratings-counter.py>)

- **Sol**
    
    ```python
    from pyspark import SparkConf, SparkContext
    import collections
    
    conf = SparkConf().setMaster("local").setAppName("RatingsHistogram")
    sc = SparkContext(conf = conf)
    
    lines = sc.textFile("file:///SparkCourse/ml-100k/u.data")
    ratings = lines.map(lambda x: x.split()[2])
    result = ratings.countByValue()
    
    sortedResults = collections.OrderedDict(sorted(result.items()))
    for key, value in sortedResults.items():
        print("%s %i" % (key, value))
    ```