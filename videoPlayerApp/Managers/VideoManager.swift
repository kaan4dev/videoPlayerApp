import Foundation

enum Query: String, CaseIterable
//CaseIterable, when you conform an enum to CaseIterable, it automatically synthesizes a static property named allCases, which is an array containing all the cases of the enum.
{
    case nature, animals, people, ocean, food
}

class VideoManager: ObservableObject
{
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.ocean
    {
        didSet
        {
            Task.init
            {
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    init()
    {
        Task.init
        {
            await findVideos(topic: selectedQuery)
        }
    }
    
    func findVideos(topic: Query) async
    {
        do
        {
            guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=10&orientation=portrait") else
            {
                fatalError("missing url")
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("jgztpKwMzvfCUNxbnOfNFFddyVkC9zvFxHM3AhwFGqpzbFfXJfrWIvNH", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else
            {
                fatalError("error while fetching data")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            self.videos = []
            self.videos = decodedData.videos
        }
        catch
        {
            print("error fetching data fromn Pexels: \(error)")
        }
    }
}

struct ResponseBody: Decodable
{
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}


struct Video: Identifiable, Decodable
{
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable
    {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable
    {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
