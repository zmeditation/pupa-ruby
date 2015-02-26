require 'openssl'

# Caches all requests, not only GET requests.
class FaradayMiddleware::Caching
  def call(env)
    # Remove if-statement to cache any request, not only GET.
    if env[:parallel_manager]
      # callback mode
      cache_on_complete(env)
    else
      # synchronous mode
      response = cache.fetch(cache_key(env)) { @app.call(env) }
      finalize_response(response, env)
    end
  end

  def cache_key(env)
    url = env[:url].dup
    if url.query && params_to_ignore.any?
      params = parse_query url.query
      params.reject! {|k,| params_to_ignore.include? k }
      url.query = params.any? ? build_query(params) : nil
    end
    url.normalize!
    url.scheme + '://' + url.host + url.request_uri + OpenSSL::Digest::MD5.hexdigest(env[:body].to_s) # XXX add for POST requests
  end
end
