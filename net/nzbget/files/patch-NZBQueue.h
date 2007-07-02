--- NZBQueue.h.orig	2007-07-02 02:04:09.000000000 -0700
+++ NZBQueue.h	2007-07-02 02:04:52.000000000 -0700
@@ -45,8 +45,13 @@ public:
 	
 	virtual Job* 		GetNextJob();
 	virtual long long 	GetWaitingSize();
+	#if __DARWIN_UNIX03
+	char* 		GetFileName() const { return m_szFileName; }
+	char*			GetBaseFileName() const { return m_szBaseFileName; }
+	#else
 	const char* 		GetFileName() const { return m_szFileName; }
 	const char*			GetBaseFileName() const { return m_szBaseFileName; }
+	#endif
 	void 				PrintProgressInfo();
 	int					GetOriginalNumberOfJobs() const { return m_iOriginalNumberOfJobs; }
 	int					GetNumberOfJobs() const { return m_Jobs.size(); }
