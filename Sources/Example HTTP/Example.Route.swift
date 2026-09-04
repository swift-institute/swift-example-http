public import Example
public import Example_Client
public import Prism_Derivation

extension Example {

    @Prisms
    public enum Route {

        case home

        case api(Call)
    }
}
