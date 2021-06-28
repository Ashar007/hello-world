private boolean checkUserIsInGroup(HttpServletRequest request)  
      throws ServletException, IOException {
   boolean isInGroup = false;  
  
   String userName = request.getParameter("UserName");
   String userFilter = String.format("(&(objectCategory=user)(CN=%s)(memberOf=%s))", userName, APPADMIN_GROUP_DN);
   try {
      DirContext ctx = new InitialLdapContext(getLdapEnvironment(), null);
     
      SearchControls searchCtl = new SearchControls();
      searchCtl.setSearchScope(SearchControls.SUBTREE_SCOPE);
      String attribNames[] = {"sAMAccountName", "memberOf"};
      searchCtl.setReturningAttributes(attribNames);
      NamingEnumeration found = ctx.search(LDAP_SEARCH_BASE, userFilter, searchCtl);
      while (found.hasMoreElements()) {
         SearchResult entry = (SearchResult)found.next();
         if (entry != null) {
            isInGroup = true;
         }
      }
      ctx.close();
   } catch (Exception ex) {
      handleExceptions(ex);
   }
  
   return isInGroup;
}
