Created a comprehensive generic network layer with the following features:
Key Features:

Full Concurrency Support: Uses Swift's modern async/await with actor isolation for thread-safe operations
Generic Request/Response: Protocol-based design allows any Decodable type to be fetched
Caching System: Built-in CacheManager actor with four cache policies:

cacheOnly: Only use cached data
networkOnly: Always fetch from network
cacheFirst: Try cache first, fall back to network
networkFirst: Try network first, fall back to cache


Error Handling: Comprehensive error types for all failure scenarios
