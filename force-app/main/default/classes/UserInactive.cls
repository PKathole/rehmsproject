public class UserInactive {
    
    @Future
    public static void getEmail(string email){
        
        List<user> u=[SELECT IsActive from user where Email=:email];
        u[0].IsActive=False;
        update u;
        
        
    }

}