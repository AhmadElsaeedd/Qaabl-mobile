# Comparison of SQL vs NoSQL Databases for a Friend-Making App

## Overview

This document provides a comprehensive comparison between SQL and NoSQL (Firebase Firestore) databases, focusing on a friend-making mobile app for students. This comparison will explore the proposed database schemas, features, advantages, disadvantages, and data manipulation methods for each type of database, specifically focusing on the matchmaking algorithm and chat retrieval functionality.

---

## Proposed Schemas

### SQL Database Schema

#### Tables

1. **Users**
   - UserID (Primary Key)
   - Name
   - Age
   - etc.

2. **Interests**
   - InterestID (Primary Key)
   - InterestName

3. **UserInterests**
   - UserID (Foreign Key)
   - InterestID (Foreign Key)

4. **Matches**
   - MatchID (Primary Key)
   - User1ID (Foreign Key)
   - User2ID (Foreign Key)
   - MatchDate

5. **Likes**
   - UserID (Foreign Key)
   - LikedUserID (Foreign Key)

6. **Dislikes**
   - UserID (Foreign Key)
   - DislikedUserID (Foreign Key)

### Firestore Database Schema

#### Collections

1. **Users**
   - UserID
   - Name
   - Age
   - Likes (Array of UserIDs)
   - Dislikes (Array of UserIDs)
   - Interests (Array of InterestIDs)
   - Matches (Array of MatchIDs)

2. **Interests**
   - InterestID
   - InterestName

3. **Matches**
   - MatchID
   - User1ID
   - User2ID
   - MatchDate

---

## Features

### SQL Database Features

1. **Normalization**: Supports data normalization which leads to data integrity.
2. **Complex Queries**: Advanced querying capabilities with JOINs.
3. **ACID Transactions**: Provides strong ACID compliance for transactions.
4. **Indexing**: More advanced indexing options for optimizing query performance.

### Firestore Database Features

1. **Denormalization**: Encourages data duplication for read efficiency.
2. **Real-Time Updates**: Optimized for real-time data synchronization.
3. **Simplicity**: Easier to set up and manage.
4. **Offline Support**: Built-in offline capabilities for mobile apps.
  
---

## Advantages and Disadvantages

### Advantages of SQL

1. **Data Integrity**: Due to normalization.
2. **Complex Querying**: Can retrieve a lot of interconnected data in a single query.
3. **Cost**: Often billed based on storage rather than per operation, which can be more cost-effective.
4. **Advanced Indexing**: For faster query execution.

### Disadvantages of SQL

1. **Complexity**: Can become complicated to design and manage.
2. **Scalability**: Manual efforts may be required for database sharding and replication for scaling.
3. **Lack of Real-Time Updates**: Not natively designed for real-time data synchronization.

### Advantages of Firestore

1. **Real-Time Updates**: Native real-time synchronization features.
2. **Simplicity**: Easier to set up and get started.
3. **Scalability**: Designed to scale automatically.
4. **Offline Support**: Built-in offline capabilities.

### Disadvantages of Firestore

1. **Cost**: Billed per operation, can become expensive.
2. **Limited Querying**: No JOIN operations and limited support for complex queries.
3. **Data Duplication**: May lead to data consistency issues due to denormalization.

---

## Methods for Use-Case

### SQL Methods

#### Matchmaking Algorithm

1. **Fetch Eligible Users**: A single SQL query can fetch all eligible users based on likes, dislikes, and interests.
2. **Update Likes/Dislikes**: INSERT operations can update the `Likes` and `Dislikes` tables.
3. **Check for Match**: A SELECT query can confirm if there's a mutual like, and a new match can be created with an INSERT operation.

#### Chat Retrieval

1. **Get Chats**: JOIN operations can fetch all chats related to a particular user efficiently.

### Firestore Methods

#### Matchmaking Algorithm

1. **Fetch Eligible Users**: Multiple reads required to fetch users and filter them based on likes and dislikes. Some client-side filtering may be needed.
2. **Update Likes/Dislikes**: Array updates for each user document.
3. **Check for Match**: Additional reads to check for a match and then updating both user documents and the `Matches` collection.

#### Chat Retrieval

1. **Get Chats**: Can fetch all chat documents related to a user in a single query but may require multiple trips to get additional details.
