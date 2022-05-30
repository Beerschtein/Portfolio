"""
Metrics

"""
import numpy as np

def hit_rate(recommended_list, bought_list):
    bought_list = np.array(bought_list)
    recommended_list = np.array(recommended_list)
    flags = np.isin(bought_list, recommended_list)
    return (flags.sum() > 0) * 1

def hit_rate_at_k(recommended_list, bought_list, k=5):
    return hit_rate(recommended_list[:k], bought_list)

def precision(recommended_list, bought_list):
    bought_list = np.array(bought_list)
    recommended_list = np.array(recommended_list)
    flags = np.isin(bought_list, recommended_list)
    return flags.sum() / len(recommended_list)

def precision_at_k(recommended_list, bought_list, k=5):
    return precision(recommended_list[:k], bought_list)

def money_precision_at_k(recommended_list, bought_list, prices_recommended, k=5):
    recommended_list = np.array(recommended_list)[:k]
    prices_recommended = np.array(prices_recommended)[:k]
    flags = np.isin(recommended_list, bought_list)
    return np.dot(flags, prices_recommended).sum() / prices_recommended.sum()

def recall(recommended_list, bought_list):
    bought_list = np.array(bought_list)
    recommended_list = np.array(recommended_list)
    flags = np.isin(bought_list, recommended_list)
    return flags.sum() / len(bought_list)


def recall_at_k(recommended_list, bought_list, k=5):
    return recall(recommended_list[:k], bought_list)


def money_recall_at_k(recommended_list, bought_list, prices_recommended, prices_bought, k=5):
    bought_list = np.array(bought_list)
    recommended_list = np.array(recommended_list)[:k]
    prices_recommended = np.array(prices_recommended)[:k]
    prices_bought = np.array(prices_bought)
    flags = np.isin(recommended_list, bought_list)
    return np.dot(flags, prices_recommended).sum() / prices_bought.sum()


# def ap_k(recommended_list, bought_list, k=5):
#     bought_list = np.array(bought_list)
#     recommended_list = np.array(recommended_list)
#     recommended_list = recommended_list[recommended_list <= k]
#
#     relevant_indexes = np.nonzero(np.isin(recommended_list, bought_list))[0]
#     if len(relevant_indexes) == 0:
#         return 0
#     amount_relevant = len(relevant_indexes)
#
#     sum_ = sum(
#         [precision_at_k(recommended_list, bought_list, k=index_relevant + 1) for index_relevant in relevant_indexes])
#     return sum_ / amount_relevant
# Эта функция от препода не работает почему-то...

def ap_k(recommended_list, bought_list, k=5):
    bought_list = np.array(bought_list)
    recommended_list = np.array(recommended_list)

    flags = np.isin(recommended_list, bought_list)

    if sum(flags) == 0:
        return 0

    sum_ = 0
    for i in range(1, k + 1):

        if flags[i] == True:
            p_k = precision_at_k(recommended_list, bought_list, k=i)
            sum_ += p_k

    result = sum_ / sum(flags)

    return result

def map_k(recommended_list, bought_list, k=5):
    # your_code
    recommended = [[143, 156, 1134, 991, 27, 1543],[1134, 991, 27, 1543, 3345, 533, 11]]
    bought = [[521, 32, 143, 991],[ 32, 143, 991, 43]]
    scores = []
    for user_recom, user_bought in zip(recommended, bought):
        apk = ap_k(user_recom, user_bought)
        scores.append(apk)
    return np.mean(scores)


def ndcg_at_k(recommended, bought):
    size = len(recommended)
    dcg = 0
    idcg = 0
    for i in len(recommended):
        if recommended[i] in bought:
            if i <= 2:
                dcg += 1 / (i + 1)
            else:
                dcg += 1 / np.log(i + 1)
                idcg += dcg
        else:
            if i <= 2:
                idcg += 1 / (i + 1)
            else:
                idcg += 1 / np.log(i + 1)
    dcg /= size
    return dcg / idcg

def r_r(user_recom, user_bought, k=5):
    # your_code
    for i, item in enumerate(user_recom[:k]):
        if item in user_bought:
            return 1 / (i + 1)
    return result

def mrr_k():
    # your_code
    recommended = [[143, 156, 1134, 991, 27, 1543],[1134, 991, 27, 1543, 3345, 533, 11]]
    bought = [[521, 32, 143, 991],[ 32, 143, 991, 43]]
    scores = []
    for user_recom, user_bought in zip(recommended, bought):
        rr_user = r_r(user_recom, user_bought)
        scores.append(rr_user)
    return np.mean(scores)

