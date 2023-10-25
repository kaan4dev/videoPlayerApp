import SwiftUI

struct QueryTag: View
{
    
    var query: Query
    var isSelected: Bool
    
    let categoryImageMapping: [Query: String] = [
           .nature: "location.magnifyingglass",
           .animals: "lizard",
           .people: "person.circle.fill",
           .ocean: "water.waves",
           .food: "carrot"
       ]
    
    var body: some View
    {
        VStack
        {
            Text(query.rawValue)
                .font(.system(size: 9))
                .bold()
                .foregroundColor(isSelected ? .black.opacity(0.5) : .gray.opacity(0.5))
                
            Image(systemName: categoryImageMapping[query] ?? "folder")
                .font(.system(size: 18))
                .foregroundColor(isSelected ? .black.opacity(0.5) : .gray.opacity(0.5))
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(10)
    }
}
    
    struct QueryTag_Previews: PreviewProvider {
        static var previews: some View {
            QueryTag(query: Query.ocean, isSelected: true)
        }
    }
